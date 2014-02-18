From: akpm@linux-foundation.org
Subject: + kernel-groupsc-remove-return-value-of-set_groups.patch added to -mm tree
Date: Tue, 18 Feb 2014 15:03:53 -0800
Message-ID: <5303e6d9.JoMAYq3c4Ajur9FQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaBRXDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 18:03:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, serge.hallyn@canonical.com, eparis@redhat.com, ebiederm@xmission.com, udknight@gmail.com

Subject: + kernel-groupsc-remove-return-value-of-set_groups.patch added to -mm tree
To: udknight@gmail.com,ebiederm@xmission.com,eparis@redhat.com,serge.hallyn@canonical.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 15:03:53 -0800


The patch titled
     Subject: kernel/groups.c: remove return value of set_groups
has been added to the -mm tree.  Its filename is
     kernel-groupsc-remove-return-value-of-set_groups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-groupsc-remove-return-value-of-set_groups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-groupsc-remove-return-value-of-set_groups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: kernel/groups.c: remove return value of set_groups

After 6307f8fee295 ("security: remove dead hook task_setgroups"),
set_groups will always return zero, so we could just remove return value
of set_groups.

This patch reduces code size, and simplfies code to use set_groups,
because we don't need to check its return value any more.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/auth.c       |    5 +----
 include/linux/cred.h |    2 +-
 kernel/groups.c      |   11 ++---------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff -puN fs/nfsd/auth.c~kernel-groupsc-remove-return-value-of-set_groups fs/nfsd/auth.c
--- a/fs/nfsd/auth.c~kernel-groupsc-remove-return-value-of-set_groups
+++ a/fs/nfsd/auth.c
@@ -71,10 +71,8 @@ int nfsd_setuser(struct svc_rqst *rqstp,
 	if (gid_eq(new->fsgid, INVALID_GID))
 		new->fsgid = exp->ex_anon_gid;
 
-	ret = set_groups(new, gi);
+	set_groups(new, gi);
 	put_group_info(gi);
-	if (ret < 0)
-		goto error;
 
 	if (!uid_eq(new->fsuid, GLOBAL_ROOT_UID))
 		new->cap_effective = cap_drop_nfsd_set(new->cap_effective);
@@ -89,7 +87,6 @@ int nfsd_setuser(struct svc_rqst *rqstp,
 
 oom:
 	ret = -ENOMEM;
-error:
 	abort_creds(new);
 	return ret;
 }
diff -puN include/linux/cred.h~kernel-groupsc-remove-return-value-of-set_groups include/linux/cred.h
--- a/include/linux/cred.h~kernel-groupsc-remove-return-value-of-set_groups
+++ a/include/linux/cred.h
@@ -66,7 +66,7 @@ extern struct group_info *groups_alloc(i
 extern struct group_info init_groups;
 extern void groups_free(struct group_info *);
 extern int set_current_groups(struct group_info *);
-extern int set_groups(struct cred *, struct group_info *);
+extern void set_groups(struct cred *, struct group_info *);
 extern int groups_search(const struct group_info *, kgid_t);
 
 /* access the groups "array" with this macro */
diff -puN kernel/groups.c~kernel-groupsc-remove-return-value-of-set_groups kernel/groups.c
--- a/kernel/groups.c~kernel-groupsc-remove-return-value-of-set_groups
+++ a/kernel/groups.c
@@ -161,13 +161,12 @@ int groups_search(const struct group_inf
  * Validate a group subscription and, if valid, insert it into a set
  * of credentials.
  */
-int set_groups(struct cred *new, struct group_info *group_info)
+void set_groups(struct cred *new, struct group_info *group_info)
 {
 	put_group_info(new->group_info);
 	groups_sort(group_info);
 	get_group_info(group_info);
 	new->group_info = group_info;
-	return 0;
 }
 
 EXPORT_SYMBOL(set_groups);
@@ -182,18 +181,12 @@ EXPORT_SYMBOL(set_groups);
 int set_current_groups(struct group_info *group_info)
 {
 	struct cred *new;
-	int ret;
 
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
 
-	ret = set_groups(new, group_info);
-	if (ret < 0) {
-		abort_creds(new);
-		return ret;
-	}
