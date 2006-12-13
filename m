From: akpm@osdl.org
Subject: - sysctl-remove-unused-context-param.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:52:23 -0800
Message-ID: <200612130652.kBD6qNi3030434@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57376 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964983AbWLMGwv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:52:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ak@suse.de, davem@davemloft.net, dhowells@redhat.com, ebiederm@xmission.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: remove unused "context" param
has been removed from the -mm tree.  Its filename was
     sysctl-remove-unused-context-param.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: remove unused "context" param
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/frv/kernel/pm.c           |    6 +--
 arch/mips/lasat/sysctl.c       |   17 +++++------
 arch/x86_64/kernel/vsyscall.c  |    3 -
 drivers/char/random.c          |    2 -
 include/linux/sysctl.h         |    5 +--
 include/net/ip.h               |    3 -
 include/net/sctp/sctp.h        |    2 -
 kernel/sysctl.c                |   47 ++++++++++++++-----------------
 net/decnet/dn_dev.c            |    6 +--
 net/decnet/sysctl_net_decnet.c |    6 +--
 net/ipv4/devinet.c             |    3 -
 net/ipv4/route.c               |    3 -
 net/ipv4/sysctl_net_ipv4.c     |   16 +++-------
 net/ipv6/addrconf.c            |    3 -
 net/ipv6/ndisc.c               |    9 +----
 15 files changed, 55 insertions(+), 76 deletions(-)

diff -puN arch/frv/kernel/pm.c~sysctl-remove-unused-context-param arch/frv/kernel/pm.c
--- a/arch/frv/kernel/pm.c~sysctl-remove-unused-context-param
+++ a/arch/frv/kernel/pm.c
@@ -223,7 +223,7 @@ static int cmode_procctl(ctl_table *ctl,
 
 static int cmode_sysctl(ctl_table *table, int __user *name, int nlen,
 			void __user *oldval, size_t __user *oldlenp,
-			void __user *newval, size_t newlen, void **context)
+			void __user *newval, size_t newlen)
 {
 	if (oldval && oldlenp) {
 		size_t oldlen;
@@ -326,7 +326,7 @@ static int p0_procctl(ctl_table *ctl, in
 
 static int p0_sysctl(ctl_table *table, int __user *name, int nlen,
 		     void __user *oldval, size_t __user *oldlenp,
-		     void __user *newval, size_t newlen, void **context)
+		     void __user *newval, size_t newlen)
 {
 	if (oldval && oldlenp) {
 		size_t oldlen;
@@ -370,7 +370,7 @@ static int cm_procctl(ctl_table *ctl, in
 
 static int cm_sysctl(ctl_table *table, int __user *name, int nlen,
 		     void __user *oldval, size_t __user *oldlenp,
-		     void __user *newval, size_t newlen, void **context)
+		     void __user *newval, size_t newlen)
 {
 	if (oldval && oldlenp) {
 		size_t oldlen;
diff -puN arch/mips/lasat/sysctl.c~sysctl-remove-unused-context-param arch/mips/lasat/sysctl.c
--- a/arch/mips/lasat/sysctl.c~sysctl-remove-unused-context-param
+++ a/arch/mips/lasat/sysctl.c
@@ -40,12 +40,12 @@ static DEFINE_MUTEX(lasat_info_mutex);
 /* Strategy function to write EEPROM after changing string entry */
 int sysctl_lasatstring(ctl_table *table, int *name, int nlen,
 		void *oldval, size_t *oldlenp,
-		void *newval, size_t newlen, void **context)
+		void *newval, size_t newlen)
 {
 	int r;
 	mutex_lock(&lasat_info_mutex);
 	r = sysctl_string(table, name,
-			  nlen, oldval, oldlenp, newval, newlen, context);
+			  nlen, oldval, oldlenp, newval, newlen);
 	if (r < 0) {
 		mutex_unlock(&lasat_info_mutex);
 		return r;
@@ -119,11 +119,11 @@ int proc_dolasatrtc(ctl_table *table, in
 /* Sysctl for setting the IP addresses */
 int sysctl_lasat_intvec(ctl_table *table, int *name, int nlen,
 		    void *oldval, size_t *oldlenp,
-		    void *newval, size_t newlen, void **context)
+		    void *newval, size_t newlen)
 {
 	int r;
 	mutex_lock(&lasat_info_mutex);
-	r = sysctl_intvec(table, name, nlen, oldval, oldlenp, newval, newlen, context);
+	r = sysctl_intvec(table, name, nlen, oldval, oldlenp, newval, newlen);
 	if (r < 0) {
 		mutex_unlock(&lasat_info_mutex);
 		return r;
@@ -139,14 +139,14 @@ int sysctl_lasat_intvec(ctl_table *table
 /* Same for RTC */
 int sysctl_lasat_rtc(ctl_table *table, int *name, int nlen,
 		    void *oldval, size_t *oldlenp,
-		    void *newval, size_t newlen, void **context)
+		    void *newval, size_t newlen)
 {
 	int r;
 	mutex_lock(&lasat_info_mutex);
 	rtctmp = ds1603_read();
 	if (rtctmp < 0)
 		rtctmp = 0;
-	r = sysctl_intvec(table, name, nlen, oldval, oldlenp, newval, newlen, context);
+	r = sysctl_intvec(table, name, nlen, oldval, oldlenp, newval, newlen);
 	if (r < 0) {
 		mutex_unlock(&lasat_info_mutex);
 		return r;
@@ -251,13 +251,12 @@ int proc_lasat_ip(ctl_table *table, int 
 
 static int sysctl_lasat_eeprom_value(ctl_table *table, int *name, int nlen,
 				     void *oldval, size_t *oldlenp,
-				     void *newval, size_t newlen,
-				     void **context)
+				     void *newval, size_t newlen)
 {
 	int r;
 
 	mutex_lock(&lasat_info_mutex);
-	r = sysctl_intvec(table, name, nlen, oldval, oldlenp, newval, newlen, context);
+	r = sysctl_intvec(table, name, nlen, oldval, oldlenp, newval, newlen);
 	if (r < 0) {
 		mutex_unlock(&lasat_info_mutex);
 		return r;
diff -puN arch/x86_64/kernel/vsyscall.c~sysctl-remove-unused-context-param arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~sysctl-remove-unused-context-param
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -225,8 +225,7 @@ out:
 
 static int vsyscall_sysctl_nostrat(ctl_table *t, int __user *name, int nlen,
 				void __user *oldval, size_t __user *oldlenp,
-				void __user *newval, size_t newlen,
-				void **context)
+				void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
diff -puN drivers/char/random.c~sysctl-remove-unused-context-param drivers/char/random.c
--- a/drivers/char/random.c~sysctl-remove-unused-context-param
+++ a/drivers/char/random.c
@@ -1203,7 +1203,7 @@ static int proc_do_uuid(ctl_table *table
 
 static int uuid_strategy(ctl_table *table, int __user *name, int nlen,
 			 void __user *oldval, size_t __user *oldlenp,
-			 void __user *newval, size_t newlen, void **context)
+			 void __user *newval, size_t newlen)
 {
 	unsigned char tmp_uuid[16], *uuid;
 	unsigned int len;
diff -puN include/linux/sysctl.h~sysctl-remove-unused-context-param include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-remove-unused-context-param
+++ a/include/linux/sysctl.h
@@ -918,8 +918,7 @@ typedef struct ctl_table ctl_table;
 
 typedef int ctl_handler (ctl_table *table, int __user *name, int nlen,
 			 void __user *oldval, size_t __user *oldlenp,
-			 void __user *newval, size_t newlen, 
-			 void **context);
+			 void __user *newval, size_t newlen);
 
 typedef int proc_handler (ctl_table *ctl, int write, struct file * filp,
 			  void __user *buffer, size_t *lenp, loff_t *ppos);
@@ -950,7 +949,7 @@ extern int do_sysctl (int __user *name, 
 extern int do_sysctl_strategy (ctl_table *table, 
 			       int __user *name, int nlen,
 			       void __user *oldval, size_t __user *oldlenp,
-			       void __user *newval, size_t newlen, void ** context);
+			       void __user *newval, size_t newlen);
 
 extern ctl_handler sysctl_string;
 extern ctl_handler sysctl_intvec;
diff -puN include/net/ip.h~sysctl-remove-unused-context-param include/net/ip.h
--- a/include/net/ip.h~sysctl-remove-unused-context-param
+++ a/include/net/ip.h
@@ -376,8 +376,7 @@ int ipv4_doint_and_flush(ctl_table *ctl,
 			 size_t *lenp, loff_t *ppos);
 int ipv4_doint_and_flush_strategy(ctl_table *table, int __user *name, int nlen,
 				  void __user *oldval, size_t __user *oldlenp,
-				  void __user *newval, size_t newlen, 
-				  void **context);
+				  void __user *newval, size_t newlen);
 #ifdef CONFIG_PROC_FS
 extern int ip_misc_proc_init(void);
 #endif
diff -puN include/net/sctp/sctp.h~sysctl-remove-unused-context-param include/net/sctp/sctp.h
--- a/include/net/sctp/sctp.h~sysctl-remove-unused-context-param
+++ a/include/net/sctp/sctp.h
@@ -368,7 +368,7 @@ static inline void sctp_sysctl_register(
 static inline void sctp_sysctl_unregister(void) { return; }
 static inline int sctp_sysctl_jiffies_ms(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen, void **context) {
+		void __user *newval, size_t newlen) {
 	return -ENOSYS;
 }
 #endif
diff -puN kernel/sysctl.c~sysctl-remove-unused-context-param kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-unused-context-param
+++ a/kernel/sysctl.c
@@ -133,7 +133,7 @@ extern int max_lock_depth;
 
 #ifdef CONFIG_SYSCTL_SYSCALL
 static int parse_table(int __user *, int, void __user *, size_t __user *,
-		void __user *, size_t, ctl_table *, void **);
+		void __user *, size_t, ctl_table *);
 #endif
 
 static int proc_do_uts_string(ctl_table *table, int write, struct file *filp,
@@ -141,12 +141,12 @@ static int proc_do_uts_string(ctl_table 
 
 static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen, void **context);
+		  void __user *newval, size_t newlen);
 
 #ifdef CONFIG_SYSVIPC
 static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen, void **context);
+		  void __user *newval, size_t newlen);
 #endif
 
 #ifdef CONFIG_PROC_SYSCTL
@@ -1243,7 +1243,6 @@ int do_sysctl(int __user *name, int nlen
 	do {
 		struct ctl_table_header *head =
 			list_entry(tmp, struct ctl_table_header, ctl_entry);
-		void *context = NULL;
 
 		if (!use_table(head))
 			continue;
@@ -1251,9 +1250,7 @@ int do_sysctl(int __user *name, int nlen
 		spin_unlock(&sysctl_lock);
 
 		error = parse_table(name, nlen, oldval, oldlenp, 
-					newval, newlen, head->ctl_table,
-					&context);
-		kfree(context);
+					newval, newlen, head->ctl_table);
 
 		spin_lock(&sysctl_lock);
 		unuse_table(head);
@@ -1309,7 +1306,7 @@ static inline int ctl_perm(ctl_table *ta
 static int parse_table(int __user *name, int nlen,
 		       void __user *oldval, size_t __user *oldlenp,
 		       void __user *newval, size_t newlen,
-		       ctl_table *table, void **context)
+		       ctl_table *table)
 {
 	int n;
 repeat:
@@ -1329,7 +1326,7 @@ repeat:
 					error = table->strategy(
 						table, name, nlen,
 						oldval, oldlenp,
-						newval, newlen, context);
+						newval, newlen);
 					if (error)
 						return error;
 				}
@@ -1340,7 +1337,7 @@ repeat:
 			}
 			error = do_sysctl_strategy(table, name, nlen,
 						   oldval, oldlenp,
-						   newval, newlen, context);
+						   newval, newlen);
 			return error;
 		}
 	}
@@ -1351,7 +1348,7 @@ repeat:
 int do_sysctl_strategy (ctl_table *table, 
 			int __user *name, int nlen,
 			void __user *oldval, size_t __user *oldlenp,
-			void __user *newval, size_t newlen, void **context)
+			void __user *newval, size_t newlen)
 {
 	int op = 0, rc;
 	size_t len;
@@ -1365,7 +1362,7 @@ int do_sysctl_strategy (ctl_table *table
 
 	if (table->strategy) {
 		rc = table->strategy(table, name, nlen, oldval, oldlenp,
-				     newval, newlen, context);
+				     newval, newlen);
 		if (rc < 0)
 			return rc;
 		if (rc > 0)
@@ -2473,7 +2470,7 @@ int proc_doulongvec_ms_jiffies_minmax(ct
 /* The generic string strategy routine: */
 int sysctl_string(ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen, void **context)
+		  void __user *newval, size_t newlen)
 {
 	if (!table->data || !table->maxlen) 
 		return -ENOTDIR;
@@ -2519,7 +2516,7 @@ int sysctl_string(ctl_table *table, int 
  */
 int sysctl_intvec(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen, void **context)
+		void __user *newval, size_t newlen)
 {
 
 	if (newval && newlen) {
@@ -2555,7 +2552,7 @@ int sysctl_intvec(ctl_table *table, int 
 /* Strategy function to convert jiffies to seconds */ 
 int sysctl_jiffies(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen, void **context)
+		void __user *newval, size_t newlen)
 {
 	if (oldval) {
 		size_t olen;
@@ -2583,7 +2580,7 @@ int sysctl_jiffies(ctl_table *table, int
 /* Strategy function to convert jiffies to seconds */ 
 int sysctl_ms_jiffies(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen, void **context)
+		void __user *newval, size_t newlen)
 {
 	if (oldval) {
 		size_t olen;
@@ -2612,7 +2609,7 @@ int sysctl_ms_jiffies(ctl_table *table, 
 /* The generic string strategy routine: */
 static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen, void **context)
+		  void __user *newval, size_t newlen)
 {
 	struct ctl_table uts_table;
 	int r, write;
@@ -2620,7 +2617,7 @@ static int sysctl_uts_string(ctl_table *
 	memcpy(&uts_table, table, sizeof(uts_table));
 	uts_table.data = get_uts(table, write);
 	r = sysctl_string(&uts_table, name, nlen,
-		oldval, oldlenp, newval, newlen, context);
+		oldval, oldlenp, newval, newlen);
 	put_uts(table, write, uts_table.data);
 	return r;
 }
@@ -2629,7 +2626,7 @@ static int sysctl_uts_string(ctl_table *
 /* The generic sysctl ipc data routine. */
 static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen, void **context)
+		void __user *newval, size_t newlen)
 {
 	size_t len;
 	void *data;
@@ -2704,41 +2701,41 @@ out:
 
 int sysctl_string(ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen, void **context)
+		  void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
 int sysctl_intvec(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen, void **context)
+		void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
 int sysctl_jiffies(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen, void **context)
+		void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
 int sysctl_ms_jiffies(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen, void **context)
+		void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 
 static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen, void **context)
+		  void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
 static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen, void **context)
+		void __user *newval, size_t newlen)
 {
 	return -ENOSYS;
 }
diff -puN net/decnet/dn_dev.c~sysctl-remove-unused-context-param net/decnet/dn_dev.c
--- a/net/decnet/dn_dev.c~sysctl-remove-unused-context-param
+++ a/net/decnet/dn_dev.c
@@ -167,8 +167,7 @@ static int dn_forwarding_proc(ctl_table 
 			void __user *, size_t *, loff_t *);
 static int dn_forwarding_sysctl(ctl_table *table, int __user *name, int nlen,
 			void __user *oldval, size_t __user *oldlenp,
-			void __user *newval, size_t newlen,
-			void **context);
+			void __user *newval, size_t newlen);
 
 static struct dn_dev_sysctl_table {
 	struct ctl_table_header *sysctl_header;
@@ -347,8 +346,7 @@ static int dn_forwarding_proc(ctl_table 
 
 static int dn_forwarding_sysctl(ctl_table *table, int __user *name, int nlen,
 			void __user *oldval, size_t __user *oldlenp,
-			void __user *newval, size_t newlen,
-			void **context)
+			void __user *newval, size_t newlen)
 {
 #ifdef CONFIG_DECNET_ROUTER
 	struct net_device *dev = table->extra1;
diff -puN net/decnet/sysctl_net_decnet.c~sysctl-remove-unused-context-param net/decnet/sysctl_net_decnet.c
--- a/net/decnet/sysctl_net_decnet.c~sysctl-remove-unused-context-param
+++ a/net/decnet/sysctl_net_decnet.c
@@ -134,8 +134,7 @@ static int parse_addr(__le16 *addr, char
 
 static int dn_node_address_strategy(ctl_table *table, int __user *name, int nlen,
 				void __user *oldval, size_t __user *oldlenp,
-				void __user *newval, size_t newlen,
-				void **context)
+				void __user *newval, size_t newlen)
 {
 	size_t len;
 	__le16 addr;
@@ -220,8 +219,7 @@ static int dn_node_address_handler(ctl_t
 
 static int dn_def_dev_strategy(ctl_table *table, int __user *name, int nlen,
 				void __user *oldval, size_t __user *oldlenp,
-				void __user *newval, size_t newlen,
-				void **context)
+				void __user *newval, size_t newlen)
 {
 	size_t len;
 	struct net_device *dev;
diff -puN net/ipv4/devinet.c~sysctl-remove-unused-context-param net/ipv4/devinet.c
--- a/net/ipv4/devinet.c~sysctl-remove-unused-context-param
+++ a/net/ipv4/devinet.c
@@ -1303,8 +1303,7 @@ int ipv4_doint_and_flush(ctl_table *ctl,
 
 int ipv4_doint_and_flush_strategy(ctl_table *table, int __user *name, int nlen,
 				  void __user *oldval, size_t __user *oldlenp,
-				  void __user *newval, size_t newlen, 
-				  void **context)
+				  void __user *newval, size_t newlen)
 {
 	int *valp = table->data;
 	int new;
diff -puN net/ipv4/route.c~sysctl-remove-unused-context-param net/ipv4/route.c
--- a/net/ipv4/route.c~sysctl-remove-unused-context-param
+++ a/net/ipv4/route.c
@@ -2872,8 +2872,7 @@ static int ipv4_sysctl_rtcache_flush_str
 						void __user *oldval,
 						size_t __user *oldlenp,
 						void __user *newval,
-						size_t newlen,
-						void **context)
+						size_t newlen)
 {
 	int delay;
 	if (newlen != sizeof(int))
diff -puN net/ipv4/sysctl_net_ipv4.c~sysctl-remove-unused-context-param net/ipv4/sysctl_net_ipv4.c
--- a/net/ipv4/sysctl_net_ipv4.c~sysctl-remove-unused-context-param
+++ a/net/ipv4/sysctl_net_ipv4.c
@@ -51,8 +51,7 @@ int ipv4_sysctl_forward(ctl_table *ctl, 
 static int ipv4_sysctl_forward_strategy(ctl_table *table,
 			 int __user *name, int nlen,
 			 void __user *oldval, size_t __user *oldlenp,
-			 void __user *newval, size_t newlen, 
-			 void **context)
+			 void __user *newval, size_t newlen)
 {
 	int *valp = table->data;
 	int new;
@@ -111,8 +110,7 @@ static int proc_tcp_congestion_control(c
 static int sysctl_tcp_congestion_control(ctl_table *table, int __user *name,
 					 int nlen, void __user *oldval,
 					 size_t __user *oldlenp,
-					 void __user *newval, size_t newlen,
-					 void **context)
+					 void __user *newval, size_t newlen)
 {
 	char val[TCP_CA_NAME_MAX];
 	ctl_table tbl = {
@@ -122,8 +120,7 @@ static int sysctl_tcp_congestion_control
 	int ret;
 
 	tcp_get_default_congestion_control(val);
-	ret = sysctl_string(&tbl, name, nlen, oldval, oldlenp, newval, newlen,
-			    context);
+	ret = sysctl_string(&tbl, name, nlen, oldval, oldlenp, newval, newlen);
 	if (ret == 0 && newval && newlen)
 		ret = tcp_set_default_congestion_control(val);
 	return ret;
@@ -169,8 +166,8 @@ static int proc_allowed_congestion_contr
 static int strategy_allowed_congestion_control(ctl_table *table, int __user *name,
 					       int nlen, void __user *oldval,
 					       size_t __user *oldlenp,
-					       void __user *newval, size_t newlen,
-					       void **context)
+					       void __user *newval,
+					       size_t newlen)
 {
 	ctl_table tbl = { .maxlen = TCP_CA_BUF_MAX };
 	int ret;
@@ -180,8 +177,7 @@ static int strategy_allowed_congestion_c
 		return -ENOMEM;
 
 	tcp_get_available_congestion_control(tbl.data, tbl.maxlen);
-	ret = sysctl_string(&tbl, name, nlen, oldval, oldlenp, newval, newlen,
-			    context);
+	ret = sysctl_string(&tbl, name, nlen, oldval, oldlenp, newval, newlen);
 	if (ret == 0 && newval && newlen)
 		ret = tcp_set_allowed_congestion_control(tbl.data);
 	kfree(tbl.data);
diff -puN net/ipv6/addrconf.c~sysctl-remove-unused-context-param net/ipv6/addrconf.c
--- a/net/ipv6/addrconf.c~sysctl-remove-unused-context-param
+++ a/net/ipv6/addrconf.c
@@ -3656,8 +3656,7 @@ static int addrconf_sysctl_forward_strat
 					    int __user *name, int nlen,
 					    void __user *oldval,
 					    size_t __user *oldlenp,
-					    void __user *newval, size_t newlen,
-					    void **context)
+					    void __user *newval, size_t newlen)
 {
 	int *valp = table->data;
 	int new;
diff -puN net/ipv6/ndisc.c~sysctl-remove-unused-context-param net/ipv6/ndisc.c
--- a/net/ipv6/ndisc.c~sysctl-remove-unused-context-param
+++ a/net/ipv6/ndisc.c
@@ -1667,8 +1667,7 @@ int ndisc_ifinfo_sysctl_change(struct ct
 static int ndisc_ifinfo_sysctl_strategy(ctl_table *ctl, int __user *name,
 					int nlen, void __user *oldval,
 					size_t __user *oldlenp,
-					void __user *newval, size_t newlen,
-					void **context)
+					void __user *newval, size_t newlen)
 {
 	struct net_device *dev = ctl->extra1;
 	struct inet6_dev *idev;
@@ -1681,14 +1680,12 @@ static int ndisc_ifinfo_sysctl_strategy(
 	switch (ctl->ctl_name) {
 	case NET_NEIGH_REACHABLE_TIME:
 		ret = sysctl_jiffies(ctl, name, nlen,
-				     oldval, oldlenp, newval, newlen,
-				     context);
+				     oldval, oldlenp, newval, newlen);
 		break;
 	case NET_NEIGH_RETRANS_TIME_MS:
 	case NET_NEIGH_REACHABLE_TIME_MS:
 		 ret = sysctl_ms_jiffies(ctl, name, nlen,
-					 oldval, oldlenp, newval, newlen,
-					 context);
+					 oldval, oldlenp, newval, newlen);
 		 break;
 	default:
 		ret = 0;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch

