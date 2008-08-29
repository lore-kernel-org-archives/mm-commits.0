From: akpm@linux-foundation.org
Subject: + sysctl-simplify-strategy.patch added to -mm tree
Date: Thu, 28 Aug 2008 17:04:10 -0700
Message-ID: <200808290004.m7T04A5Q021371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427AbYH2AFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 20:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, davem@davemloft.net, dhowells@redhat.com, ebiederm@xmission.com, mpm@selenic.com, ralf@linux-mips.org


The patch titled
     sysctl: simplify ->strategy
has been added to the -mm tree.  Its filename is
     sysctl-simplify-strategy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: simplify ->strategy
From: Alexey Dobriyan <adobriyan@gmail.com>

name and nlen parameters passed to ->strategy hook are unused, remove
them.  In general ->strategy hook should know what it's doing, and don't
do something tricky for which, say, pointer to original userspace array
may be needed (name).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/pm.c           |    6 +++---
 arch/mips/lasat/sysctl.c       |   17 ++++++++---------
 drivers/char/random.c          |    2 +-
 include/linux/sysctl.h         |    2 +-
 include/net/ip.h               |    2 +-
 include/net/ndisc.h            |    5 ++---
 ipc/ipc_sysctl.c               |    9 ++++-----
 kernel/sysctl.c                |   29 +++++++++++++----------------
 kernel/utsname_sysctl.c        |    5 ++---
 net/decnet/dn_dev.c            |    4 ++--
 net/decnet/sysctl_net_decnet.c |    4 ++--
 net/ipv4/devinet.c             |    7 +++----
 net/ipv4/route.c               |    7 +------
 net/ipv4/sysctl_net_ipv4.c     |   18 +++++++++---------
 net/ipv6/addrconf.c            |    1 -
 net/ipv6/ndisc.c               |   11 ++++-------
 16 files changed, 56 insertions(+), 73 deletions(-)

diff -puN arch/frv/kernel/pm.c~sysctl-simplify-strategy arch/frv/kernel/pm.c
--- a/arch/frv/kernel/pm.c~sysctl-simplify-strategy
+++ a/arch/frv/kernel/pm.c
@@ -211,7 +211,7 @@ static int cmode_procctl(ctl_table *ctl,
 	return try_set_cmode(new_cmode)?:*lenp;
 }
 
-static int cmode_sysctl(ctl_table *table, int __user *name, int nlen,
+static int cmode_sysctl(ctl_table *table,
 			void __user *oldval, size_t __user *oldlenp,
 			void __user *newval, size_t newlen)
 {
@@ -314,7 +314,7 @@ static int p0_procctl(ctl_table *ctl, in
 	return try_set_p0(new_p0)?:*lenp;
 }
 
-static int p0_sysctl(ctl_table *table, int __user *name, int nlen,
+static int p0_sysctl(ctl_table *table,
 		     void __user *oldval, size_t __user *oldlenp,
 		     void __user *newval, size_t newlen)
 {
@@ -358,7 +358,7 @@ static int cm_procctl(ctl_table *ctl, in
 	return try_set_cm(new_cm)?:*lenp;
 }
 
-static int cm_sysctl(ctl_table *table, int __user *name, int nlen,
+static int cm_sysctl(ctl_table *table,
 		     void __user *oldval, size_t __user *oldlenp,
 		     void __user *newval, size_t newlen)
 {
diff -puN arch/mips/lasat/sysctl.c~sysctl-simplify-strategy arch/mips/lasat/sysctl.c
--- a/arch/mips/lasat/sysctl.c~sysctl-simplify-strategy
+++ a/arch/mips/lasat/sysctl.c
@@ -38,14 +38,13 @@
 #endif
 
 /* Strategy function to write EEPROM after changing string entry */
-int sysctl_lasatstring(ctl_table *table, int *name, int nlen,
+int sysctl_lasatstring(ctl_table *table,
 		void *oldval, size_t *oldlenp,
 		void *newval, size_t newlen)
 {
 	int r;
 
-	r = sysctl_string(table, name,
-			  nlen, oldval, oldlenp, newval, newlen);
+	r = sysctl_string(table, oldval, oldlenp, newval, newlen);
 	if (r < 0)
 		return r;
 
@@ -113,13 +112,13 @@ int proc_dolasatrtc(ctl_table *table, in
 #endif
 
 /* Sysctl for setting the IP addresses */
-int sysctl_lasat_intvec(ctl_table *table, int *name, int nlen,
+int sysctl_lasat_intvec(ctl_table *table,
 		    void *oldval, size_t *oldlenp,
 		    void *newval, size_t newlen)
 {
 	int r;
 
-	r = sysctl_intvec(table, name, nlen, oldval, oldlenp, newval, newlen);
+	r = sysctl_intvec(table, oldval, oldlenp, newval, newlen);
 	if (r < 0)
 		return r;
 
@@ -131,7 +130,7 @@ int sysctl_lasat_intvec(ctl_table *table
 
 #ifdef CONFIG_DS1603
 /* Same for RTC */
-int sysctl_lasat_rtc(ctl_table *table, int *name, int nlen,
+int sysctl_lasat_rtc(ctl_table *table,
 		    void *oldval, size_t *oldlenp,
 		    void *newval, size_t newlen)
 {
@@ -140,7 +139,7 @@ int sysctl_lasat_rtc(ctl_table *table, i
 	rtctmp = read_persistent_clock();
 	if (rtctmp < 0)
 		rtctmp = 0;
-	r = sysctl_intvec(table, name, nlen, oldval, oldlenp, newval, newlen);
+	r = sysctl_intvec(table, oldval, oldlenp, newval, newlen);
 	if (r < 0)
 		return r;
 	if (newval && newlen)
@@ -211,13 +210,13 @@ int proc_lasat_ip(ctl_table *table, int 
 }
 #endif
 
-static int sysctl_lasat_prid(ctl_table *table, int *name, int nlen,
+static int sysctl_lasat_prid(ctl_table *table,
 				     void *oldval, size_t *oldlenp,
 				     void *newval, size_t newlen)
 {
 	int r;
 
-	r = sysctl_intvec(table, name, nlen, oldval, oldlenp, newval, newlen);
+	r = sysctl_intvec(table, oldval, oldlenp, newval, newlen);
 	if (r < 0)
 		return r;
 	if (newval && newlen) {
diff -puN drivers/char/random.c~sysctl-simplify-strategy drivers/char/random.c
--- a/drivers/char/random.c~sysctl-simplify-strategy
+++ a/drivers/char/random.c
@@ -1266,7 +1266,7 @@ static int proc_do_uuid(ctl_table *table
 	return proc_dostring(&fake_table, write, filp, buffer, lenp, ppos);
 }
 
-static int uuid_strategy(ctl_table *table, int __user *name, int nlen,
+static int uuid_strategy(ctl_table *table,
 			 void __user *oldval, size_t __user *oldlenp,
 			 void __user *newval, size_t newlen)
 {
diff -puN include/linux/sysctl.h~sysctl-simplify-strategy include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-simplify-strategy
+++ a/include/linux/sysctl.h
@@ -972,7 +972,7 @@ extern int sysctl_perm(struct ctl_table_
 
 typedef struct ctl_table ctl_table;
 
-typedef int ctl_handler (struct ctl_table *table, int __user *name, int nlen,
+typedef int ctl_handler (struct ctl_table *table,
 			 void __user *oldval, size_t __user *oldlenp,
 			 void __user *newval, size_t newlen);
 
diff -puN include/net/ip.h~sysctl-simplify-strategy include/net/ip.h
--- a/include/net/ip.h~sysctl-simplify-strategy
+++ a/include/net/ip.h
@@ -383,7 +383,7 @@ extern void	ip_local_error(struct sock *
 int ipv4_doint_and_flush(ctl_table *ctl, int write,
 			 struct file* filp, void __user *buffer,
 			 size_t *lenp, loff_t *ppos);
-int ipv4_doint_and_flush_strategy(ctl_table *table, int __user *name, int nlen,
+int ipv4_doint_and_flush_strategy(ctl_table *table,
 				  void __user *oldval, size_t __user *oldlenp,
 				  void __user *newval, size_t newlen);
 #ifdef CONFIG_PROC_FS
diff -puN include/net/ndisc.h~sysctl-simplify-strategy include/net/ndisc.h
--- a/include/net/ndisc.h~sysctl-simplify-strategy
+++ a/include/net/ndisc.h
@@ -129,9 +129,8 @@ extern int 			ndisc_ifinfo_sysctl_change
 							   void __user *buffer,
 							   size_t *lenp,
 							   loff_t *ppos);
-int ndisc_ifinfo_sysctl_strategy(ctl_table *ctl, int __user *name,
-				 int nlen, void __user *oldval,
-				 size_t __user *oldlenp,
+int ndisc_ifinfo_sysctl_strategy(ctl_table *ctl,
+				 void __user *oldval, size_t __user *oldlenp,
 				 void __user *newval, size_t newlen);
 #endif
 
diff -puN ipc/ipc_sysctl.c~sysctl-simplify-strategy ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~sysctl-simplify-strategy
+++ a/ipc/ipc_sysctl.c
@@ -131,7 +131,7 @@ static int proc_ipcauto_dointvec_minmax(
 
 #ifdef CONFIG_SYSCTL_SYSCALL
 /* The generic sysctl ipc data routine. */
-static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
+static int sysctl_ipc_data(ctl_table *table,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -169,14 +169,13 @@ static int sysctl_ipc_data(ctl_table *ta
 	return 1;
 }
 
-static int sysctl_ipc_registered_data(ctl_table *table, int __user *name,
-		int nlen, void __user *oldval, size_t __user *oldlenp,
+static int sysctl_ipc_registered_data(ctl_table *table,
+		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
 	int rc;
 
-	rc = sysctl_ipc_data(table, name, nlen, oldval, oldlenp, newval,
-		newlen);
+	rc = sysctl_ipc_data(table, oldval, oldlenp, newval, newlen);
 
 	if (newval && newlen && rc > 0)
 		/*
diff -puN kernel/sysctl.c~sysctl-simplify-strategy kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-simplify-strategy
+++ a/kernel/sysctl.c
@@ -1555,7 +1555,6 @@ void register_sysctl_root(struct ctl_tab
 /* Perform the actual read/write of a sysctl table entry. */
 static int do_sysctl_strategy(struct ctl_table_root *root,
 			struct ctl_table *table,
-			int __user *name, int nlen,
 			void __user *oldval, size_t __user *oldlenp,
 			void __user *newval, size_t newlen)
 {
@@ -1569,8 +1568,7 @@ static int do_sysctl_strategy(struct ctl
 		return -EPERM;
 
 	if (table->strategy) {
-		rc = table->strategy(table, name, nlen, oldval, oldlenp,
-				     newval, newlen);
+		rc = table->strategy(table, oldval, oldlenp, newval, newlen);
 		if (rc < 0)
 			return rc;
 		if (rc > 0)
@@ -1580,8 +1578,7 @@ static int do_sysctl_strategy(struct ctl
 	/* If there is no strategy routine, or if the strategy returns
 	 * zero, proceed with automatic r/w */
 	if (table->data && table->maxlen) {
-		rc = sysctl_data(table, name, nlen, oldval, oldlenp,
-				 newval, newlen);
+		rc = sysctl_data(table, oldval, oldlenp, newval, newlen);
 		if (rc < 0)
 			return rc;
 	}
@@ -1613,7 +1610,7 @@ repeat:
 				table = table->child;
 				goto repeat;
 			}
-			error = do_sysctl_strategy(root, table, name, nlen,
+			error = do_sysctl_strategy(root, table,
 						   oldval, oldlenp,
 						   newval, newlen);
 			return error;
@@ -2772,7 +2769,7 @@ int proc_doulongvec_ms_jiffies_minmax(st
  */
 
 /* The generic sysctl data routine (used if no strategy routine supplied) */
-int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
+int sysctl_data(struct ctl_table *table,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -2806,7 +2803,7 @@ int sysctl_data(struct ctl_table *table,
 }
 
 /* The generic string strategy routine: */
-int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
+int sysctl_string(struct ctl_table *table,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
 {
@@ -2852,7 +2849,7 @@ int sysctl_string(struct ctl_table *tabl
  * are between the minimum and maximum values given in the arrays
  * table->extra1 and table->extra2, respectively.
  */
-int sysctl_intvec(struct ctl_table *table, int __user *name, int nlen,
+int sysctl_intvec(struct ctl_table *table,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -2888,7 +2885,7 @@ int sysctl_intvec(struct ctl_table *tabl
 }
 
 /* Strategy function to convert jiffies to seconds */ 
-int sysctl_jiffies(struct ctl_table *table, int __user *name, int nlen,
+int sysctl_jiffies(struct ctl_table *table,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -2922,7 +2919,7 @@ int sysctl_jiffies(struct ctl_table *tab
 }
 
 /* Strategy function to convert jiffies to seconds */ 
-int sysctl_ms_jiffies(struct ctl_table *table, int __user *name, int nlen,
+int sysctl_ms_jiffies(struct ctl_table *table,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
@@ -2977,35 +2974,35 @@ asmlinkage long sys_sysctl(struct __sysc
 	return error;
 }
 
-int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
+int sysctl_data(struct ctl_table *table,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
-int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
+int sysctl_string(struct ctl_table *table,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
-int sysctl_intvec(struct ctl_table *table, int __user *name, int nlen,
+int sysctl_intvec(struct ctl_table *table,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
-int sysctl_jiffies(struct ctl_table *table, int __user *name, int nlen,
+int sysctl_jiffies(struct ctl_table *table,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
-int sysctl_ms_jiffies(struct ctl_table *table, int __user *name, int nlen,
+int sysctl_ms_jiffies(struct ctl_table *table,
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
diff -puN kernel/utsname_sysctl.c~sysctl-simplify-strategy kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~sysctl-simplify-strategy
+++ a/kernel/utsname_sysctl.c
@@ -60,7 +60,7 @@ static int proc_do_uts_string(ctl_table 
 
 #ifdef CONFIG_SYSCTL_SYSCALL
 /* The generic string strategy routine: */
-static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
+static int sysctl_uts_string(ctl_table *table,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
 {
@@ -69,8 +69,7 @@ static int sysctl_uts_string(ctl_table *
 	write = newval && newlen;
 	memcpy(&uts_table, table, sizeof(uts_table));
 	uts_table.data = get_uts(table, write);
-	r = sysctl_string(&uts_table, name, nlen,
-		oldval, oldlenp, newval, newlen);
+	r = sysctl_string(&uts_table, oldval, oldlenp, newval, newlen);
 	put_uts(table, write, uts_table.data);
 	return r;
 }
diff -puN net/decnet/dn_dev.c~sysctl-simplify-strategy net/decnet/dn_dev.c
--- a/net/decnet/dn_dev.c~sysctl-simplify-strategy
+++ a/net/decnet/dn_dev.c
@@ -166,7 +166,7 @@ static int max_priority[] = { 127 }; /* 
 
 static int dn_forwarding_proc(ctl_table *, int, struct file *,
 			void __user *, size_t *, loff_t *);
-static int dn_forwarding_sysctl(ctl_table *table, int __user *name, int nlen,
+static int dn_forwarding_sysctl(ctl_table *table,
 			void __user *oldval, size_t __user *oldlenp,
 			void __user *newval, size_t newlen);
 
@@ -318,7 +318,7 @@ static int dn_forwarding_proc(ctl_table 
 #endif
 }
 
-static int dn_forwarding_sysctl(ctl_table *table, int __user *name, int nlen,
+static int dn_forwarding_sysctl(ctl_table *table,
 			void __user *oldval, size_t __user *oldlenp,
 			void __user *newval, size_t newlen)
 {
diff -puN net/decnet/sysctl_net_decnet.c~sysctl-simplify-strategy net/decnet/sysctl_net_decnet.c
--- a/net/decnet/sysctl_net_decnet.c~sysctl-simplify-strategy
+++ a/net/decnet/sysctl_net_decnet.c
@@ -132,7 +132,7 @@ static int parse_addr(__le16 *addr, char
 }
 
 
-static int dn_node_address_strategy(ctl_table *table, int __user *name, int nlen,
+static int dn_node_address_strategy(ctl_table *table,
 				void __user *oldval, size_t __user *oldlenp,
 				void __user *newval, size_t newlen)
 {
@@ -217,7 +217,7 @@ static int dn_node_address_handler(ctl_t
 }
 
 
-static int dn_def_dev_strategy(ctl_table *table, int __user *name, int nlen,
+static int dn_def_dev_strategy(ctl_table *table,
 				void __user *oldval, size_t __user *oldlenp,
 				void __user *newval, size_t newlen)
 {
diff -puN net/ipv4/devinet.c~sysctl-simplify-strategy net/ipv4/devinet.c
--- a/net/ipv4/devinet.c~sysctl-simplify-strategy
+++ a/net/ipv4/devinet.c
@@ -1272,7 +1272,7 @@ static int devinet_conf_proc(ctl_table *
 	return ret;
 }
 
-static int devinet_conf_sysctl(ctl_table *table, int __user *name, int nlen,
+static int devinet_conf_sysctl(ctl_table *table,
 			       void __user *oldval, size_t __user *oldlenp,
 			       void __user *newval, size_t newlen)
 {
@@ -1368,12 +1368,11 @@ int ipv4_doint_and_flush(ctl_table *ctl,
 	return ret;
 }
 
-int ipv4_doint_and_flush_strategy(ctl_table *table, int __user *name, int nlen,
+int ipv4_doint_and_flush_strategy(ctl_table *table,
 				  void __user *oldval, size_t __user *oldlenp,
 				  void __user *newval, size_t newlen)
 {
-	int ret = devinet_conf_sysctl(table, name, nlen, oldval, oldlenp,
-				      newval, newlen);
+	int ret = devinet_conf_sysctl(table, oldval, oldlenp, newval, newlen);
 	struct net *net = table->extra2;
 
 	if (ret == 1)
diff -puN net/ipv4/route.c~sysctl-simplify-strategy net/ipv4/route.c
--- a/net/ipv4/route.c~sysctl-simplify-strategy
+++ a/net/ipv4/route.c
@@ -2896,8 +2896,6 @@ static int ipv4_sysctl_rtcache_flush(ctl
 }
 
 static int ipv4_sysctl_rtcache_flush_strategy(ctl_table *table,
-						int __user *name,
-						int nlen,
 						void __user *oldval,
 						size_t __user *oldlenp,
 						void __user *newval,
@@ -2960,16 +2958,13 @@ static int ipv4_sysctl_rt_secret_interva
 }
 
 static int ipv4_sysctl_rt_secret_interval_strategy(ctl_table *table,
-						   int __user *name,
-						   int nlen,
 						   void __user *oldval,
 						   size_t __user *oldlenp,
 						   void __user *newval,
 						   size_t newlen)
 {
 	int old = ip_rt_secret_interval;
-	int ret = sysctl_jiffies(table, name, nlen, oldval, oldlenp, newval,
-				 newlen);
+	int ret = sysctl_jiffies(table, oldval, oldlenp, newval, newlen);
 
 	rt_secret_reschedule(old);
 
diff -puN net/ipv4/sysctl_net_ipv4.c~sysctl-simplify-strategy net/ipv4/sysctl_net_ipv4.c
--- a/net/ipv4/sysctl_net_ipv4.c~sysctl-simplify-strategy
+++ a/net/ipv4/sysctl_net_ipv4.c
@@ -67,8 +67,8 @@ static int ipv4_local_port_range(ctl_tab
 }
 
 /* Validate changes from sysctl interface. */
-static int ipv4_sysctl_local_port_range(ctl_table *table, int __user *name,
-					 int nlen, void __user *oldval,
+static int ipv4_sysctl_local_port_range(ctl_table *table,
+					 void __user *oldval,
 					 size_t __user *oldlenp,
 					void __user *newval, size_t newlen)
 {
@@ -83,7 +83,7 @@ static int ipv4_sysctl_local_port_range(
 		.extra2 = &ip_local_port_range_max,
 	};
 
-	ret = sysctl_intvec(&tmp, name, nlen, oldval, oldlenp, newval, newlen);
+	ret = sysctl_intvec(&tmp, oldval, oldlenp, newval, newlen);
 	if (ret == 0 && newval && newlen) {
 		if (range[1] < range[0])
 			ret = -EINVAL;
@@ -112,8 +112,8 @@ static int proc_tcp_congestion_control(c
 	return ret;
 }
 
-static int sysctl_tcp_congestion_control(ctl_table *table, int __user *name,
-					 int nlen, void __user *oldval,
+static int sysctl_tcp_congestion_control(ctl_table *table,
+					 void __user *oldval,
 					 size_t __user *oldlenp,
 					 void __user *newval, size_t newlen)
 {
@@ -125,7 +125,7 @@ static int sysctl_tcp_congestion_control
 	int ret;
 
 	tcp_get_default_congestion_control(val);
-	ret = sysctl_string(&tbl, name, nlen, oldval, oldlenp, newval, newlen);
+	ret = sysctl_string(&tbl, oldval, oldlenp, newval, newlen);
 	if (ret == 1 && newval && newlen)
 		ret = tcp_set_default_congestion_control(val);
 	return ret;
@@ -168,8 +168,8 @@ static int proc_allowed_congestion_contr
 	return ret;
 }
 
-static int strategy_allowed_congestion_control(ctl_table *table, int __user *name,
-					       int nlen, void __user *oldval,
+static int strategy_allowed_congestion_control(ctl_table *table,
+					       void __user *oldval,
 					       size_t __user *oldlenp,
 					       void __user *newval,
 					       size_t newlen)
@@ -182,7 +182,7 @@ static int strategy_allowed_congestion_c
 		return -ENOMEM;
 
 	tcp_get_available_congestion_control(tbl.data, tbl.maxlen);
-	ret = sysctl_string(&tbl, name, nlen, oldval, oldlenp, newval, newlen);
+	ret = sysctl_string(&tbl, oldval, oldlenp, newval, newlen);
 	if (ret == 1 && newval && newlen)
 		ret = tcp_set_allowed_congestion_control(tbl.data);
 	kfree(tbl.data);
diff -puN net/ipv6/addrconf.c~sysctl-simplify-strategy net/ipv6/addrconf.c
--- a/net/ipv6/addrconf.c~sysctl-simplify-strategy
+++ a/net/ipv6/addrconf.c
@@ -3982,7 +3982,6 @@ int addrconf_sysctl_forward(ctl_table *c
 }
 
 static int addrconf_sysctl_forward_strategy(ctl_table *table,
-					    int __user *name, int nlen,
 					    void __user *oldval,
 					    size_t __user *oldlenp,
 					    void __user *newval, size_t newlen)
diff -puN net/ipv6/ndisc.c~sysctl-simplify-strategy net/ipv6/ndisc.c
--- a/net/ipv6/ndisc.c~sysctl-simplify-strategy
+++ a/net/ipv6/ndisc.c
@@ -1730,9 +1730,8 @@ int ndisc_ifinfo_sysctl_change(struct ct
 	return ret;
 }
 
-int ndisc_ifinfo_sysctl_strategy(ctl_table *ctl, int __user *name,
-				 int nlen, void __user *oldval,
-				 size_t __user *oldlenp,
+int ndisc_ifinfo_sysctl_strategy(ctl_table *ctl,
+				 void __user *oldval, size_t __user *oldlenp,
 				 void __user *newval, size_t newlen)
 {
 	struct net_device *dev = ctl->extra1;
@@ -1745,13 +1744,11 @@ int ndisc_ifinfo_sysctl_strategy(ctl_tab
 
 	switch (ctl->ctl_name) {
 	case NET_NEIGH_REACHABLE_TIME:
-		ret = sysctl_jiffies(ctl, name, nlen,
-				     oldval, oldlenp, newval, newlen);
+		ret = sysctl_jiffies(ctl, oldval, oldlenp, newval, newlen);
 		break;
 	case NET_NEIGH_RETRANS_TIME_MS:
 	case NET_NEIGH_REACHABLE_TIME_MS:
-		 ret = sysctl_ms_jiffies(ctl, name, nlen,
-					 oldval, oldlenp, newval, newlen);
+		 ret = sysctl_ms_jiffies(ctl, oldval, oldlenp, newval, newlen);
 		 break;
 	default:
 		ret = 0;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
anondev-init-idr-statically.patch
anondev-switch-to-ida.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
sysctl-simplify-strategy.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

