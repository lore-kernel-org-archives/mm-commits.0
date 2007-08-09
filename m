From: akpm@linux-foundation.org
Subject: + sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch added to -mm tree
Date: Thu, 09 Aug 2007 15:11:46 -0700
Message-ID: <200708092211.l79MBkBv022129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbXHIWMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 18:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@sw.ru


The patch titled
     sysctl core: Stop using the unnecessary ctl_table typedef
has been added to the -mm tree.  Its filename is
     sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl core: Stop using the unnecessary ctl_table typedef
From: Eric W. Biederman <ebiederm@xmission.com>

In sysctl.h the typedef struct ctl_table ctl_table violates coding style isn't
needed and is a bit of a nuisance because it makes it harder to recognize
ctl_table is a type name.

So this patch removes it from the generic sysctl code.  Hopefully I will have
enough energy to send the rest of my patches will follow and to remove it from
the rest of the kernel.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |   36 ++++++------
 kernel/sysctl.c        |  114 +++++++++++++++++++--------------------
 2 files changed, 75 insertions(+), 75 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-core-stop-using-the-unnecessary-ctl_table-typedef include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-core-stop-using-the-unnecessary-ctl_table-typedef
+++ a/include/linux/sysctl.h
@@ -937,37 +937,37 @@ extern int sysctl_perm(struct ctl_table 
 
 typedef struct ctl_table ctl_table;
 
-typedef int ctl_handler (ctl_table *table, int __user *name, int nlen,
+typedef int ctl_handler (struct ctl_table *table, int __user *name, int nlen,
 			 void __user *oldval, size_t __user *oldlenp,
 			 void __user *newval, size_t newlen);
 
-typedef int proc_handler (ctl_table *ctl, int write, struct file * filp,
+typedef int proc_handler (struct ctl_table *ctl, int write, struct file * filp,
 			  void __user *buffer, size_t *lenp, loff_t *ppos);
 
-extern int proc_dostring(ctl_table *, int, struct file *,
+extern int proc_dostring(struct ctl_table *, int, struct file *,
 			 void __user *, size_t *, loff_t *);
-extern int proc_dointvec(ctl_table *, int, struct file *,
+extern int proc_dointvec(struct ctl_table *, int, struct file *,
 			 void __user *, size_t *, loff_t *);
-extern int proc_dointvec_bset(ctl_table *, int, struct file *,
+extern int proc_dointvec_bset(struct ctl_table *, int, struct file *,
 			      void __user *, size_t *, loff_t *);
-extern int proc_dointvec_minmax(ctl_table *, int, struct file *,
+extern int proc_dointvec_minmax(struct ctl_table *, int, struct file *,
 				void __user *, size_t *, loff_t *);
-extern int proc_dointvec_jiffies(ctl_table *, int, struct file *,
+extern int proc_dointvec_jiffies(struct ctl_table *, int, struct file *,
 				 void __user *, size_t *, loff_t *);
-extern int proc_dointvec_userhz_jiffies(ctl_table *, int, struct file *,
+extern int proc_dointvec_userhz_jiffies(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
-extern int proc_dointvec_ms_jiffies(ctl_table *, int, struct file *,
+extern int proc_dointvec_ms_jiffies(struct ctl_table *, int, struct file *,
 				    void __user *, size_t *, loff_t *);
-extern int proc_doulongvec_minmax(ctl_table *, int, struct file *,
+extern int proc_doulongvec_minmax(struct ctl_table *, int, struct file *,
 				  void __user *, size_t *, loff_t *);
-extern int proc_doulongvec_ms_jiffies_minmax(ctl_table *table, int,
+extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
 				      struct file *, void __user *, size_t *, loff_t *);
 
 extern int do_sysctl (int __user *name, int nlen,
 		      void __user *oldval, size_t __user *oldlenp,
 		      void __user *newval, size_t newlen);
 
-extern int do_sysctl_strategy (ctl_table *table, 
+extern int do_sysctl_strategy (struct ctl_table *table,
 			       int __user *name, int nlen,
 			       void __user *oldval, size_t __user *oldlenp,
 			       void __user *newval, size_t newlen);
@@ -980,7 +980,7 @@ extern ctl_handler sysctl_ms_jiffies;
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
- * with an initialised array of ctl_table's.  An entry with zero
+ * with an initialised array of struct ctl_table's.  An entry with zero
  * ctl_name and NULL procname terminates the table.  table->de will be
  * set up by the registration and need not be initialised in advance.
  *
@@ -1026,8 +1026,8 @@ struct ctl_table 
 	void *data;
 	int maxlen;
 	mode_t mode;
-	ctl_table *child;
-	ctl_table *parent;		/* Automatically set */
+	struct ctl_table *child;
+	struct ctl_table *parent;	/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	ctl_handler *strategy;		/* Callback function for all r/w */
 	void *extra1;
@@ -1035,16 +1035,16 @@ struct ctl_table 
 };
 
 /* struct ctl_table_header is used to maintain dynamic lists of
-   ctl_table trees. */
+   struct ctl_table trees. */
 struct ctl_table_header
 {
-	ctl_table *ctl_table;
+	struct ctl_table *ctl_table;
 	struct list_head ctl_entry;
 	int used;
 	struct completion *unregistering;
 };
 
-struct ctl_table_header * register_sysctl_table(ctl_table * table);
+struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
 
 void unregister_sysctl_table(struct ctl_table_header * table);
 
diff -puN kernel/sysctl.c~sysctl-core-stop-using-the-unnecessary-ctl_table-typedef kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-core-stop-using-the-unnecessary-ctl_table-typedef
+++ a/kernel/sysctl.c
@@ -142,32 +142,32 @@ extern int max_lock_depth;
 
 #ifdef CONFIG_SYSCTL_SYSCALL
 static int parse_table(int __user *, int, void __user *, size_t __user *,
-		void __user *, size_t, ctl_table *);
+		void __user *, size_t, struct ctl_table *);
 #endif
 
 
 #ifdef CONFIG_PROC_SYSCTL
-static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
+static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
-static int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
+static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
-static ctl_table root_table[];
+static struct ctl_table root_table[];
 static struct ctl_table_header root_table_header =
 	{ root_table, LIST_HEAD_INIT(root_table_header.ctl_entry) };
 
-static ctl_table kern_table[];
-static ctl_table vm_table[];
-static ctl_table fs_table[];
-static ctl_table debug_table[];
-static ctl_table dev_table[];
-extern ctl_table random_table[];
+static struct ctl_table kern_table[];
+static struct ctl_table vm_table[];
+static struct ctl_table fs_table[];
+static struct ctl_table debug_table[];
+static struct ctl_table dev_table[];
+extern struct ctl_table random_table[];
 #ifdef CONFIG_UNIX98_PTYS
-extern ctl_table pty_table[];
+extern struct ctl_table pty_table[];
 #endif
 #ifdef CONFIG_INOTIFY_USER
-extern ctl_table inotify_table[];
+extern struct ctl_table inotify_table[];
 #endif
 
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
@@ -179,7 +179,7 @@ extern int lock_stat;
 
 /* The default sysctl tables: */
 
-static ctl_table root_table[] = {
+static struct ctl_table root_table[] = {
 	{
 		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
@@ -232,7 +232,7 @@ static unsigned long min_wakeup_granular
 static unsigned long max_wakeup_granularity_ns = 1000000000;	/* 1 second */
 #endif
 
-static ctl_table kern_table[] = {
+static struct ctl_table kern_table[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -781,7 +781,7 @@ static ctl_table kern_table[] = {
 	{ .ctl_name = 0 }
 };
 
-static ctl_table vm_table[] = {
+static struct ctl_table vm_table[] = {
 	{
 		.ctl_name	= VM_OVERCOMMIT_MEMORY,
 		.procname	= "overcommit_memory",
@@ -1101,12 +1101,12 @@ static ctl_table vm_table[] = {
 };
 
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
-static ctl_table binfmt_misc_table[] = {
+static struct ctl_table binfmt_misc_table[] = {
 	{ .ctl_name = 0 }
 };
 #endif
 
-static ctl_table fs_table[] = {
+static struct ctl_table fs_table[] = {
 	{
 		.ctl_name	= FS_NRINODE,
 		.procname	= "inode-nr",
@@ -1263,11 +1263,11 @@ static ctl_table fs_table[] = {
 	{ .ctl_name = 0 }
 };
 
-static ctl_table debug_table[] = {
+static struct ctl_table debug_table[] = {
 	{ .ctl_name = 0 }
 };
 
-static ctl_table dev_table[] = {
+static struct ctl_table dev_table[] = {
 	{ .ctl_name = 0 }
 };
 
@@ -1407,7 +1407,7 @@ static int test_perm(int mode, int op)
 	return -EACCES;
 }
 
-int sysctl_perm(ctl_table *table, int op)
+int sysctl_perm(struct ctl_table *table, int op)
 {
 	int error;
 	error = security_sysctl(table, op);
@@ -1420,7 +1420,7 @@ int sysctl_perm(ctl_table *table, int op
 static int parse_table(int __user *name, int nlen,
 		       void __user *oldval, size_t __user *oldlenp,
 		       void __user *newval, size_t newlen,
-		       ctl_table *table)
+		       struct ctl_table *table)
 {
 	int n;
 repeat:
@@ -1451,7 +1451,7 @@ repeat:
 }
 
 /* Perform the actual read/write of a sysctl table entry. */
-int do_sysctl_strategy (ctl_table *table, 
+int do_sysctl_strategy (struct ctl_table *table,
 			int __user *name, int nlen,
 			void __user *oldval, size_t __user *oldlenp,
 			void __user *newval, size_t newlen)
@@ -1526,7 +1526,7 @@ core_initcall(sysctl_init);
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
  * array. An entry with a ctl_name of 0 terminates the table. 
  *
- * The members of the &ctl_table structure are used as follows:
+ * The members of the &struct ctl_table structure are used as follows:
  *
  * ctl_name - This is the numeric sysctl value used by sysctl(2). The number
  *            must be unique within that level of sysctl
@@ -1587,7 +1587,7 @@ core_initcall(sysctl_init);
  * This routine returns %NULL on a failure to register, and a pointer
  * to the table header on success.
  */
-struct ctl_table_header *register_sysctl_table(ctl_table * table)
+struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
 {
 	struct ctl_table_header *tmp;
 	tmp = kmalloc(sizeof(struct ctl_table_header), GFP_KERNEL);
@@ -1621,7 +1621,7 @@ void unregister_sysctl_table(struct ctl_
 }
 
 #else /* !CONFIG_SYSCTL */
-struct ctl_table_header *register_sysctl_table(ctl_table * table)
+struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
 {
 	return NULL;
 }
@@ -1714,7 +1714,7 @@ static int _proc_do_string(void* data, i
  *
  * Returns 0 on success.
  */
-int proc_dostring(ctl_table *table, int write, struct file *filp,
+int proc_dostring(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return _proc_do_string(table->data, table->maxlen, write, filp,
@@ -1741,7 +1741,7 @@ static int do_proc_dointvec_conv(int *ne
 	return 0;
 }
 
-static int __do_proc_dointvec(void *tbl_data, ctl_table *table,
+static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		  int write, struct file *filp, void __user *buffer,
 		  size_t *lenp, loff_t *ppos,
 		  int (*conv)(int *negp, unsigned long *lvalp, int *valp,
@@ -1851,7 +1851,7 @@ static int __do_proc_dointvec(void *tbl_
 #undef TMPBUFLEN
 }
 
-static int do_proc_dointvec(ctl_table *table, int write, struct file *filp,
+static int do_proc_dointvec(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos,
 		  int (*conv)(int *negp, unsigned long *lvalp, int *valp,
 			      int write, void *data),
@@ -1875,7 +1875,7 @@ static int do_proc_dointvec(ctl_table *t
  *
  * Returns 0 on success.
  */
-int proc_dointvec(ctl_table *table, int write, struct file *filp,
+int proc_dointvec(struct ctl_table *table, int write, struct file *filp,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
     return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
@@ -1915,7 +1915,7 @@ static int do_proc_dointvec_bset_conv(in
  *	init may raise the set.
  */
  
-int proc_dointvec_bset(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_bset(struct ctl_table *table, int write, struct file *filp,
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int op;
@@ -1932,7 +1932,7 @@ int proc_dointvec_bset(ctl_table *table,
 /*
  *	Taint values can only be increased
  */
-static int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
+static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int op;
@@ -1991,7 +1991,7 @@ static int do_proc_dointvec_minmax_conv(
  *
  * Returns 0 on success.
  */
-int proc_dointvec_minmax(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_minmax(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct do_proc_dointvec_minmax_conv_param param = {
@@ -2002,7 +2002,7 @@ int proc_dointvec_minmax(ctl_table *tabl
 				do_proc_dointvec_minmax_conv, &param);
 }
 
-static int __do_proc_doulongvec_minmax(void *data, ctl_table *table, int write,
+static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     struct file *filp,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
@@ -2107,7 +2107,7 @@ static int __do_proc_doulongvec_minmax(v
 #undef TMPBUFLEN
 }
 
-static int do_proc_doulongvec_minmax(ctl_table *table, int write,
+static int do_proc_doulongvec_minmax(struct ctl_table *table, int write,
 				     struct file *filp,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
@@ -2135,7 +2135,7 @@ static int do_proc_doulongvec_minmax(ctl
  *
  * Returns 0 on success.
  */
-int proc_doulongvec_minmax(ctl_table *table, int write, struct file *filp,
+int proc_doulongvec_minmax(struct ctl_table *table, int write, struct file *filp,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
     return do_proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos, 1l, 1l);
@@ -2159,7 +2159,7 @@ int proc_doulongvec_minmax(ctl_table *ta
  *
  * Returns 0 on success.
  */
-int proc_doulongvec_ms_jiffies_minmax(ctl_table *table, int write,
+int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 				      struct file *filp,
 				      void __user *buffer,
 				      size_t *lenp, loff_t *ppos)
@@ -2252,7 +2252,7 @@ static int do_proc_dointvec_ms_jiffies_c
  *
  * Returns 0 on success.
  */
-int proc_dointvec_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_jiffies(struct ctl_table *table, int write, struct file *filp,
 			  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
     return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
@@ -2275,7 +2275,7 @@ int proc_dointvec_jiffies(ctl_table *tab
  *
  * Returns 0 on success.
  */
-int proc_dointvec_userhz_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write, struct file *filp,
 				 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
     return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
@@ -2299,14 +2299,14 @@ int proc_dointvec_userhz_jiffies(ctl_tab
  *
  * Returns 0 on success.
  */
-int proc_dointvec_ms_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_ms_jiffies(struct ctl_table *table, int write, struct file *filp,
 			     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return do_proc_dointvec(table, write, filp, buffer, lenp, ppos,
 				do_proc_dointvec_ms_jiffies_conv, NULL);
 }
 
-static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
+static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct pid *new_pid;
@@ -2330,55 +2330,55 @@ static int proc_do_cad_pid(ctl_table *ta
 
 #else /* CONFIG_PROC_FS */
 
-int proc_dostring(ctl_table *table, int write, struct file *filp,
+int proc_dostring(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec(ctl_table *table, int write, struct file *filp,
+int proc_dointvec(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_bset(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_bset(struct ctl_table *table, int write, struct file *filp,
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_minmax(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_minmax(struct ctl_table *table, int write, struct file *filp,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_jiffies(struct ctl_table *table, int write, struct file *filp,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_userhz_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write, struct file *filp,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_ms_jiffies(ctl_table *table, int write, struct file *filp,
+int proc_dointvec_ms_jiffies(struct ctl_table *table, int write, struct file *filp,
 			     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_doulongvec_minmax(ctl_table *table, int write, struct file *filp,
+int proc_doulongvec_minmax(struct ctl_table *table, int write, struct file *filp,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_doulongvec_ms_jiffies_minmax(ctl_table *table, int write,
+int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 				      struct file *filp,
 				      void __user *buffer,
 				      size_t *lenp, loff_t *ppos)
@@ -2396,7 +2396,7 @@ int proc_doulongvec_ms_jiffies_minmax(ct
  */
 
 /* The generic string strategy routine: */
-int sysctl_string(ctl_table *table, int __user *name, int nlen,
+int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
 {
@@ -2442,7 +2442,7 @@ int sysctl_string(ctl_table *table, int 
  * are between the minimum and maximum values given in the arrays
  * table->extra1 and table->extra2, respectively.
  */
-int sysctl_intvec(ctl_table *table, int __user *name, int nlen,
+int sysctl_intvec(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -2478,7 +2478,7 @@ int sysctl_intvec(ctl_table *table, int 
 }
 
 /* Strategy function to convert jiffies to seconds */ 
-int sysctl_jiffies(ctl_table *table, int __user *name, int nlen,
+int sysctl_jiffies(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -2512,7 +2512,7 @@ int sysctl_jiffies(ctl_table *table, int
 }
 
 /* Strategy function to convert jiffies to seconds */ 
-int sysctl_ms_jiffies(ctl_table *table, int __user *name, int nlen,
+int sysctl_ms_jiffies(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -2583,28 +2583,28 @@ out:
 	return -ENOSYS;
 }
 
-int sysctl_string(ctl_table *table, int __user *name, int nlen,
+int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
-int sysctl_intvec(ctl_table *table, int __user *name, int nlen,
+int sysctl_intvec(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
-int sysctl_jiffies(ctl_table *table, int __user *name, int nlen,
+int sysctl_jiffies(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
-int sysctl_ms_jiffies(ctl_table *table, int __user *name, int nlen,
+int sysctl_ms_jiffies(struct ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
_

Patches currently in -mm which might be from ebiederm@xmission.com are

remove-unused-struct-proc_dir_entryset.patch
dvb_en_50221-convert-to-kthread-api.patch
x86_64-remove-sync_arb_ids.patch
x86_64-clear-io_apic-before-enabing-apic-error-vector.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
handle-the-multi-threaded-inits-exit-properly.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysctl-error-on-bad-sysctl-tables.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
