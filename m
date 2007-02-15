From: akpm@linux-foundation.org
Subject: - knfsd-allow-the-server-to-provide-a-gid-list-when-using-auth_unix-authentication.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:51 -0800
Message-ID: <200702150847.l1F8lp3b025013@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39948 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965371AbXBOIrz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: allow the server to provide a gid list when using AUTH_UNIX authentication
has been removed from the -mm tree.  Its filename was
     knfsd-allow-the-server-to-provide-a-gid-list-when-using-auth_unix-authentication.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: allow the server to provide a gid list when using AUTH_UNIX authentication
From: NeilBrown <neilb@suse.de>

AUTH_UNIX authentication (the standard with NFS) has a limit of 16 groups ids.
 This causes problems for people in more than 16 groups.

So allow the server to map a uid into a list of group ids based on local
knowledge rather depending on the (possibly truncated) list from the client.

If there is no process on the server responding to upcalls, the gidlist in the
request will still be used.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/sunrpc_syms.c  |    5 
 net/sunrpc/svcauth_unix.c |  225 +++++++++++++++++++++++++++++++++++-
 2 files changed, 224 insertions(+), 6 deletions(-)

diff -puN net/sunrpc/sunrpc_syms.c~knfsd-allow-the-server-to-provide-a-gid-list-when-using-auth_unix-authentication net/sunrpc/sunrpc_syms.c
--- a/net/sunrpc/sunrpc_syms.c~knfsd-allow-the-server-to-provide-a-gid-list-when-using-auth_unix-authentication
+++ a/net/sunrpc/sunrpc_syms.c
@@ -137,7 +137,7 @@ EXPORT_SYMBOL(nlm_debug);
 
 extern int register_rpc_pipefs(void);
 extern void unregister_rpc_pipefs(void);
-extern struct cache_detail ip_map_cache;
+extern struct cache_detail ip_map_cache, unix_gid_cache;
 extern int init_socket_xprt(void);
 extern void cleanup_socket_xprt(void);
 
@@ -157,6 +157,7 @@ init_sunrpc(void)
 	rpc_proc_init();
 #endif
 	cache_register(&ip_map_cache);
+	cache_register(&unix_gid_cache);
 	init_socket_xprt();
 out:
 	return err;
@@ -170,6 +171,8 @@ cleanup_sunrpc(void)
 	rpc_destroy_mempool();
 	if (cache_unregister(&ip_map_cache))
 		printk(KERN_ERR "sunrpc: failed to unregister ip_map cache\n");
+	if (cache_unregister(&unix_gid_cache))
+	      printk(KERN_ERR "sunrpc: failed to unregister unix_gid cache\n");
 #ifdef RPC_DEBUG
 	rpc_unregister_sysctl();
 #endif
diff -puN net/sunrpc/svcauth_unix.c~knfsd-allow-the-server-to-provide-a-gid-list-when-using-auth_unix-authentication net/sunrpc/svcauth_unix.c
--- a/net/sunrpc/svcauth_unix.c~knfsd-allow-the-server-to-provide-a-gid-list-when-using-auth_unix-authentication
+++ a/net/sunrpc/svcauth_unix.c
@@ -418,6 +418,214 @@ svcauth_unix_info_release(void *info)
 	cache_put(&ipm->h, &ip_map_cache);
 }
 
+/****************************************************************************
+ * auth.unix.gid cache
+ * simple cache to map a UID to a list of GIDs
+ * because AUTH_UNIX aka AUTH_SYS has a max of 16
+ */
+#define	GID_HASHBITS	8
+#define	GID_HASHMAX	(1<<GID_HASHBITS)
+#define	GID_HASHMASK	(GID_HASHMAX - 1)
+
+struct unix_gid {
+	struct cache_head	h;
+	uid_t			uid;
+	struct group_info	*gi;
+};
+static struct cache_head	*gid_table[GID_HASHMAX];
+
+static void unix_gid_put(struct kref *kref)
+{
+	struct cache_head *item = container_of(kref, struct cache_head, ref);
+	struct unix_gid *ug = container_of(item, struct unix_gid, h);
+	if (test_bit(CACHE_VALID, &item->flags) &&
+	    !test_bit(CACHE_NEGATIVE, &item->flags))
+		put_group_info(ug->gi);
+	kfree(ug);
+}
+
+static int unix_gid_match(struct cache_head *corig, struct cache_head *cnew)
+{
+	struct unix_gid *orig = container_of(corig, struct unix_gid, h);
+	struct unix_gid *new = container_of(cnew, struct unix_gid, h);
+	return orig->uid == new->uid;
+}
+static void unix_gid_init(struct cache_head *cnew, struct cache_head *citem)
+{
+	struct unix_gid *new = container_of(cnew, struct unix_gid, h);
+	struct unix_gid *item = container_of(citem, struct unix_gid, h);
+	new->uid = item->uid;
+}
+static void unix_gid_update(struct cache_head *cnew, struct cache_head *citem)
+{
+	struct unix_gid *new = container_of(cnew, struct unix_gid, h);
+	struct unix_gid *item = container_of(citem, struct unix_gid, h);
+
+	get_group_info(item->gi);
+	new->gi = item->gi;
+}
+static struct cache_head *unix_gid_alloc(void)
+{
+	struct unix_gid *g = kmalloc(sizeof(*g), GFP_KERNEL);
+	if (g)
+		return &g->h;
+	else
+		return NULL;
+}
+
+static void unix_gid_request(struct cache_detail *cd,
+			     struct cache_head *h,
+			     char **bpp, int *blen)
+{
+	char tuid[20];
+	struct unix_gid *ug = container_of(h, struct unix_gid, h);
+
+	snprintf(tuid, 20, "%u", ug->uid);
+	qword_add(bpp, blen, tuid);
+	(*bpp)[-1] = '\n';
+}
+
+static struct unix_gid *unix_gid_lookup(uid_t uid);
+extern struct cache_detail unix_gid_cache;
+
+static int unix_gid_parse(struct cache_detail *cd,
+			char *mesg, int mlen)
+{
+	/* uid expiry Ngid gid0 gid1 ... gidN-1 */
+	int uid;
+	int gids;
+	int rv;
+	int i;
+	int err;
+	time_t expiry;
+	struct unix_gid ug, *ugp;
+
+	if (mlen <= 0 || mesg[mlen-1] != '\n')
+		return -EINVAL;
+	mesg[mlen-1] = 0;
+
+	rv = get_int(&mesg, &uid);
+	if (rv)
+		return -EINVAL;
+	ug.uid = uid;
+
+	expiry = get_expiry(&mesg);
+	if (expiry == 0)
+		return -EINVAL;
+
+	rv = get_int(&mesg, &gids);
+	if (rv || gids < 0 || gids > 8192)
+		return -EINVAL;
+
+	ug.gi = groups_alloc(gids);
+	if (!ug.gi)
+		return -ENOMEM;
+
+	for (i = 0 ; i < gids ; i++) {
+		int gid;
+		rv = get_int(&mesg, &gid);
+		err = -EINVAL;
+		if (rv)
+			goto out;
+		GROUP_AT(ug.gi, i) = gid;
+	}
+
+	ugp = unix_gid_lookup(uid);
+	if (ugp) {
+		struct cache_head *ch;
+		ug.h.flags = 0;
+		ug.h.expiry_time = expiry;
+		ch = sunrpc_cache_update(&unix_gid_cache,
+					 &ug.h, &ugp->h,
+					 hash_long(uid, GID_HASHBITS));
+		if (!ch)
+			err = -ENOMEM;
+		else {
+			err = 0;
+			cache_put(ch, &unix_gid_cache);
+		}
+	} else
+		err = -ENOMEM;
+ out:
+	if (ug.gi)
+		put_group_info(ug.gi);
+	return err;
+}
+
+static int unix_gid_show(struct seq_file *m,
+			 struct cache_detail *cd,
+			 struct cache_head *h)
+{
+	struct unix_gid *ug;
+	int i;
+	int glen;
+
+	if (h == NULL) {
+		seq_puts(m, "#uid cnt: gids...\n");
+		return 0;
+	}
+	ug = container_of(h, struct unix_gid, h);
+	if (test_bit(CACHE_VALID, &h->flags) &&
+	    !test_bit(CACHE_NEGATIVE, &h->flags))
+		glen = ug->gi->ngroups;
+	else
+		glen = 0;
+
+	seq_printf(m, "%d %d:", ug->uid, glen);
+	for (i = 0; i < glen; i++)
+		seq_printf(m, " %d", GROUP_AT(ug->gi, i));
+	seq_printf(m, "\n");
+	return 0;
+}
+
+struct cache_detail unix_gid_cache = {
+	.owner		= THIS_MODULE,
+	.hash_size	= GID_HASHMAX,
+	.hash_table	= gid_table,
+	.name		= "auth.unix.gid",
+	.cache_put	= unix_gid_put,
+	.cache_request	= unix_gid_request,
+	.cache_parse	= unix_gid_parse,
+	.cache_show	= unix_gid_show,
+	.match		= unix_gid_match,
+	.init		= unix_gid_init,
+	.update		= unix_gid_update,
+	.alloc		= unix_gid_alloc,
+};
+
+static struct unix_gid *unix_gid_lookup(uid_t uid)
+{
+	struct unix_gid ug;
+	struct cache_head *ch;
+
+	ug.uid = uid;
+	ch = sunrpc_cache_lookup(&unix_gid_cache, &ug.h,
+				 hash_long(uid, GID_HASHBITS));
+	if (ch)
+		return container_of(ch, struct unix_gid, h);
+	else
+		return NULL;
+}
+
+static int unix_gid_find(uid_t uid, struct group_info **gip,
+			 struct svc_rqst *rqstp)
+{
+	struct unix_gid *ug = unix_gid_lookup(uid);
+	if (!ug)
+		return -EAGAIN;
+	switch (cache_check(&unix_gid_cache, &ug->h, &rqstp->rq_chandle)) {
+	case -ENOENT:
+		*gip = NULL;
+		return 0;
+	case 0:
+		*gip = ug->gi;
+		get_group_info(*gip);
+		return 0;
+	default:
+		return -EAGAIN;
+	}
+}
+
 static int
 svcauth_unix_set_client(struct svc_rqst *rqstp)
 {
@@ -543,12 +751,19 @@ svcauth_unix_accept(struct svc_rqst *rqs
 	slen = svc_getnl(argv);			/* gids length */
 	if (slen > 16 || (len -= (slen + 2)*4) < 0)
 		goto badcred;
-	cred->cr_group_info = groups_alloc(slen);
-	if (cred->cr_group_info == NULL)
+	if (unix_gid_find(cred->cr_uid, &cred->cr_group_info, rqstp)
+	    == -EAGAIN)
 		return SVC_DROP;
-	for (i = 0; i < slen; i++)
-		GROUP_AT(cred->cr_group_info, i) = svc_getnl(argv);
-
+	if (cred->cr_group_info == NULL) {
+		cred->cr_group_info = groups_alloc(slen);
+		if (cred->cr_group_info == NULL)
+			return SVC_DROP;
+		for (i = 0; i < slen; i++)
+			GROUP_AT(cred->cr_group_info, i) = svc_getnl(argv);
+	} else {
+		for (i = 0; i < slen ; i++)
+			svc_getnl(argv);
+	}
 	if (svc_getu32(argv) != htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {
 		*authp = rpc_autherr_badverf;
 		return SVC_DENIED;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
knfsd-nfsd4-fix-non-terminated-string.patch
knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch
knfsd-nfsd4-simplify-nfsv4-posix-translation.patch
knfsd-nfsd4-represent-nfsv4-acl-with-array-instead-of-linked-list.patch
knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem.patch
knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch
knfsd-nfsd4-acls-dont-return-explicit-mask.patch
knfsd-nfsd4-acls-avoid-unnecessary-denies.patch
knfsd-nfsd4-fix-handling-of-directories-without-default-acls.patch
knfsd-stop-nfsd-writes-from-being-broken-into-lots-of-little-writes-to-filesystem.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
