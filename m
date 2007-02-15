From: akpm@linux-foundation.org
Subject: - sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:48 -0800
Message-ID: <200702150850.l1F8omxd025254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40236 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965515AbXBOIux (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, jmorris@namei.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     sysctl: remove the proc_dir_entry member for the sysctl tables
has been removed from the -mm tree.  Its filename was
     sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: remove the proc_dir_entry member for the sysctl tables
From: Eric W. Biederman <ebiederm@xmission.com>

It isn't needed anymore, all of the users are gone, and all of the ctl_table
initializers have been converted to use explicit names of the fields they are
initializing.

[akpm@osdl.org: NTFS fix]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/sysctl.c         |    8 -------
 include/linux/sysctl.h   |    1 
 net/decnet/dn_dev.c      |    5 ----
 net/ipv4/devinet.c       |    5 ----
 net/ipv6/addrconf.c      |    5 ----
 security/selinux/hooks.c |   39 +++++++++++++++++++++++++++++++++++--
 6 files changed, 37 insertions(+), 26 deletions(-)

diff -puN fs/ntfs/sysctl.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables fs/ntfs/sysctl.c
--- a/fs/ntfs/sysctl.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables
+++ a/fs/ntfs/sysctl.c
@@ -73,14 +73,6 @@ int ntfs_sysctl(int add)
 		sysctls_root_table = register_sysctl_table(sysctls_root);
 		if (!sysctls_root_table)
 			return -ENOMEM;
-#ifdef CONFIG_PROC_FS
-		/*
-		 * If the proc filesystem is in use and we are a module, need
-		 * to set the owner of our proc entry to our module. In the
-		 * non-modular case, THIS_MODULE is NULL, so this is ok.
-		 */
-		ntfs_sysctls[0].de->owner = THIS_MODULE;
-#endif
 	} else {
 		BUG_ON(!sysctls_root_table);
 		unregister_sysctl_table(sysctls_root_table);
diff -puN include/linux/sysctl.h~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables
+++ a/include/linux/sysctl.h
@@ -1025,7 +1025,6 @@ struct ctl_table 
 	ctl_table *parent;		/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	ctl_handler *strategy;		/* Callback function for all r/w */
-	struct proc_dir_entry *de;	/* /proc control block */
 	void *extra1;
 	void *extra2;
 };
diff -puN net/decnet/dn_dev.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables net/decnet/dn_dev.c
--- a/net/decnet/dn_dev.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables
+++ a/net/decnet/dn_dev.c
@@ -261,7 +261,6 @@ static void dn_dev_sysctl_register(struc
 	for(i = 0; i < ARRAY_SIZE(t->dn_dev_vars) - 1; i++) {
 		long offset = (long)t->dn_dev_vars[i].data;
 		t->dn_dev_vars[i].data = ((char *)parms) + offset;
-		t->dn_dev_vars[i].de = NULL;
 	}
 
 	if (dev) {
@@ -273,13 +272,9 @@ static void dn_dev_sysctl_register(struc
 	}
 
 	t->dn_dev_dev[0].child = t->dn_dev_vars;
-	t->dn_dev_dev[0].de = NULL;
 	t->dn_dev_conf_dir[0].child = t->dn_dev_dev;
-	t->dn_dev_conf_dir[0].de = NULL;
 	t->dn_dev_proto_dir[0].child = t->dn_dev_conf_dir;
-	t->dn_dev_proto_dir[0].de = NULL;
 	t->dn_dev_root_dir[0].child = t->dn_dev_proto_dir;
-	t->dn_dev_root_dir[0].de = NULL;
 	t->dn_dev_vars[0].extra1 = (void *)dev;
 
 	t->sysctl_header = register_sysctl_table(t->dn_dev_root_dir);
diff -puN net/ipv4/devinet.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables net/ipv4/devinet.c
--- a/net/ipv4/devinet.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables
+++ a/net/ipv4/devinet.c
@@ -1576,7 +1576,6 @@ static void devinet_sysctl_register(stru
 		return;
 	for (i = 0; i < ARRAY_SIZE(t->devinet_vars) - 1; i++) {
 		t->devinet_vars[i].data += (char *)p - (char *)&ipv4_devconf;
-		t->devinet_vars[i].de = NULL;
 	}
 
 	if (dev) {
@@ -1598,13 +1597,9 @@ static void devinet_sysctl_register(stru
 
 	t->devinet_dev[0].procname    = dev_name;
 	t->devinet_dev[0].child	      = t->devinet_vars;
-	t->devinet_dev[0].de	      = NULL;
 	t->devinet_conf_dir[0].child  = t->devinet_dev;
-	t->devinet_conf_dir[0].de     = NULL;
 	t->devinet_proto_dir[0].child = t->devinet_conf_dir;
-	t->devinet_proto_dir[0].de    = NULL;
 	t->devinet_root_dir[0].child  = t->devinet_proto_dir;
-	t->devinet_root_dir[0].de     = NULL;
 
 	t->sysctl_header = register_sysctl_table(t->devinet_root_dir);
 	if (!t->sysctl_header)
diff -puN net/ipv6/addrconf.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables net/ipv6/addrconf.c
--- a/net/ipv6/addrconf.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables
+++ a/net/ipv6/addrconf.c
@@ -3998,7 +3998,6 @@ static void addrconf_sysctl_register(str
 		return;
 	for (i=0; t->addrconf_vars[i].data; i++) {
 		t->addrconf_vars[i].data += (char*)p - (char*)&ipv6_devconf;
-		t->addrconf_vars[i].de = NULL;
 		t->addrconf_vars[i].extra1 = idev; /* embedded; no ref */
 	}
 	if (dev) {
@@ -4021,13 +4020,9 @@ static void addrconf_sysctl_register(str
 	t->addrconf_dev[0].procname = dev_name;
 
 	t->addrconf_dev[0].child = t->addrconf_vars;
-	t->addrconf_dev[0].de = NULL;
 	t->addrconf_conf_dir[0].child = t->addrconf_dev;
-	t->addrconf_conf_dir[0].de = NULL;
 	t->addrconf_proto_dir[0].child = t->addrconf_conf_dir;
-	t->addrconf_proto_dir[0].de = NULL;
 	t->addrconf_root_dir[0].child = t->addrconf_proto_dir;
-	t->addrconf_root_dir[0].de = NULL;
 
 	t->sysctl_header = register_sysctl_table(t->addrconf_root_dir);
 	if (t->sysctl_header == NULL)
diff -puN security/selinux/hooks.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables security/selinux/hooks.c
--- a/security/selinux/hooks.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables
+++ a/security/selinux/hooks.c
@@ -1423,6 +1423,41 @@ static int selinux_capable(struct task_s
 	return task_has_capability(tsk,cap);
 }
 
+static int selinux_sysctl_get_sid(ctl_table *table, u16 tclass, u32 *sid)
+{
+	int buflen, rc;
+	char *buffer, *path, *end;
+
+	rc = -ENOMEM;
+	buffer = (char*)__get_free_page(GFP_KERNEL);
+	if (!buffer)
+		goto out;
+
+	buflen = PAGE_SIZE;
+	end = buffer+buflen;
+	*--end = '\0';
+	buflen--;
+	path = end-1;
+	*path = '/';
+	while (table) {
+		const char *name = table->procname;
+		size_t namelen = strlen(name);
+		buflen -= namelen + 1;
+		if (buflen < 0)
+			goto out_free;
+		end -= namelen;
+		memcpy(end, name, namelen);
+		*--end = '/';
+		path = end;
+		table = table->parent;
+	}
+	rc = security_genfs_sid("proc", path, tclass, sid);
+out_free:
+	free_page((unsigned long)buffer);
+out:
+	return rc;
+}
+
 static int selinux_sysctl(ctl_table *table, int op)
 {
 	int error = 0;
@@ -1437,8 +1472,8 @@ static int selinux_sysctl(ctl_table *tab
 
 	tsec = current->security;
 
-	rc = selinux_proc_get_sid(table->de, (op == 001) ?
-	                          SECCLASS_DIR : SECCLASS_FILE, &tsid);
+	rc = selinux_sysctl_get_sid(table, (op == 0001) ?
+				    SECCLASS_DIR : SECCLASS_FILE, &tsid);
 	if (rc) {
 		/* Default to the well-defined sysctl SID. */
 		tsid = SECINITSID_SYSCTL;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
