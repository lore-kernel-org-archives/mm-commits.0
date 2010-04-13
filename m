From: akpm@linux-foundation.org
Subject: + kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min.patch added to -mm tree
Date: Tue, 13 Apr 2010 12:42:56 -0700
Message-ID: <201004131942.o3DJgu41023751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071Ab0DMTn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 15:43:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     kernel-wide: replace USHORT_MAX, SHORT_MAX and SHORT_MIN with USHRT_MAX, SHRT_MAX and SHRT_MIN
has been added to the -mm tree.  Its filename is
     kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-wide: replace USHORT_MAX, SHORT_MAX and SHORT_MIN with USHRT_MAX, SHRT_MAX and SHRT_MIN
From: Alexey Dobriyan <adobriyan@gmail.com>

- C99 knows about USHRT_MAX/SHRT_MAX/SHRT_MIN, not
  USHORT_MAX/SHORT_MAX/SHORT_MIN.

- Make SHRT_MIN of type s16, not int, for consistency.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fcoe/fcoe.c              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c   |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_config.c |    2 +-
 drivers/vhost/vhost.c                 |    2 +-
 fs/nfs/super.c                        |    4 ++--
 fs/nfsd/nfsctl.c                      |    4 ++--
 fs/ocfs2/blockcheck.c                 |    4 ++--
 include/linux/kernel.h                |    6 +++---
 include/linux/sched.h                 |    2 +-
 include/net/ip.h                      |    6 +++---
 include/net/ipv6.h                    |    6 +++---
 ipc/msg.c                             |   12 ++++++------
 ipc/util.c                            |    4 ++--
 lib/vsprintf.c                        |    2 +-
 net/9p/protocol.c                     |    2 +-
 net/dccp/options.c                    |    2 +-
 net/ipv4/udp.c                        |    8 ++++----
 net/mac80211/sta_info.c               |    2 +-
 net/sunrpc/rpcb_clnt.c                |    2 +-
 19 files changed, 37 insertions(+), 37 deletions(-)

diff -puN drivers/scsi/fcoe/fcoe.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min drivers/scsi/fcoe/fcoe.c
--- a/drivers/scsi/fcoe/fcoe.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/drivers/scsi/fcoe/fcoe.c
@@ -685,7 +685,7 @@ static int fcoe_shost_config(struct fc_l
 	}
 
 	if (!lport->vport)
-		fc_host_max_npiv_vports(lport->host) = USHORT_MAX;
+		fc_host_max_npiv_vports(lport->host) = USHRT_MAX;
 
 	snprintf(fc_host_symbolic_name(lport->host), FC_SYMBOLIC_NAME_SIZE,
 		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
diff -puN drivers/scsi/mpt2sas/mpt2sas_base.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min drivers/scsi/mpt2sas/mpt2sas_base.c
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3757,7 +3757,7 @@ _base_reset_handler(struct MPT2SAS_ADAPT
 		if (ioc->config_cmds.status & MPT2_CMD_PENDING) {
 			ioc->config_cmds.status |= MPT2_CMD_RESET;
 			mpt2sas_base_free_smid(ioc, ioc->config_cmds.smid);
-			ioc->config_cmds.smid = USHORT_MAX;
+			ioc->config_cmds.smid = USHRT_MAX;
 			complete(&ioc->config_cmds.done);
 		}
 		break;
diff -puN drivers/scsi/mpt2sas/mpt2sas_config.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min drivers/scsi/mpt2sas/mpt2sas_config.c
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -258,7 +258,7 @@ mpt2sas_config_done(struct MPT2SAS_ADAPT
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	_config_display_some_debug(ioc, smid, "config_done", mpi_reply);
 #endif
-	ioc->config_cmds.smid = USHORT_MAX;
+	ioc->config_cmds.smid = USHRT_MAX;
 	complete(&ioc->config_cmds.done);
 	return 1;
 }
diff -puN drivers/vhost/vhost.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min drivers/vhost/vhost.c
--- a/drivers/vhost/vhost.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/drivers/vhost/vhost.c
@@ -806,7 +806,7 @@ static unsigned get_indirect(struct vhos
 	count = indirect->len / sizeof desc;
 	/* Buffers are chained via a 16 bit next field, so
 	 * we can have at most 2^16 of these. */
-	if (count > USHORT_MAX + 1) {
+	if (count > USHRT_MAX + 1) {
 		vq_err(vq, "Indirect buffer length too big: %d\n",
 		       indirect->len);
 		return -E2BIG;
diff -puN fs/nfs/super.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min fs/nfs/super.c
--- a/fs/nfs/super.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/fs/nfs/super.c
@@ -1064,7 +1064,7 @@ static int nfs_parse_mount_options(char 
 				goto out_nomem;
 			rc = strict_strtoul(string, 10, &option);
 			kfree(string);
-			if (rc != 0 || option > USHORT_MAX)
+			if (rc != 0 || option > USHRT_MAX)
 				goto out_invalid_value;
 			mnt->nfs_server.port = option;
 			break;
@@ -1185,7 +1185,7 @@ static int nfs_parse_mount_options(char 
 				goto out_nomem;
 			rc = strict_strtoul(string, 10, &option);
 			kfree(string);
-			if (rc != 0 || option > USHORT_MAX)
+			if (rc != 0 || option > USHRT_MAX)
 				goto out_invalid_value;
 			mnt->mount_server.port = option;
 			break;
diff -puN fs/nfsd/nfsctl.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min fs/nfsd/nfsctl.c
--- a/fs/nfsd/nfsctl.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/fs/nfsd/nfsctl.c
@@ -998,7 +998,7 @@ static ssize_t __write_ports_addxprt(cha
 	if (sscanf(buf, "%15s %4u", transport, &port) != 2)
 		return -EINVAL;
 
-	if (port < 1 || port > USHORT_MAX)
+	if (port < 1 || port > USHRT_MAX)
 		return -EINVAL;
 
 	err = nfsd_create_serv();
@@ -1040,7 +1040,7 @@ static ssize_t __write_ports_delxprt(cha
 	if (sscanf(&buf[1], "%15s %4u", transport, &port) != 2)
 		return -EINVAL;
 
-	if (port < 1 || port > USHORT_MAX || nfsd_serv == NULL)
+	if (port < 1 || port > USHRT_MAX || nfsd_serv == NULL)
 		return -EINVAL;
 
 	xprt = svc_find_xprt(nfsd_serv, transport, AF_UNSPEC, port);
diff -puN fs/ocfs2/blockcheck.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min fs/ocfs2/blockcheck.c
--- a/fs/ocfs2/blockcheck.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/fs/ocfs2/blockcheck.c
@@ -403,7 +403,7 @@ void ocfs2_block_check_compute(void *dat
 	 * No ecc'd ocfs2 structure is larger than 4K, so ecc will be no
 	 * larger than 16 bits.
 	 */
-	BUG_ON(ecc > USHORT_MAX);
+	BUG_ON(ecc > USHRT_MAX);
 
 	bc->bc_crc32e = cpu_to_le32(crc);
 	bc->bc_ecc = cpu_to_le16((u16)ecc);
@@ -508,7 +508,7 @@ void ocfs2_block_check_compute_bhs(struc
 	 * No ecc'd ocfs2 structure is larger than 4K, so ecc will be no
 	 * larger than 16 bits.
 	 */
-	BUG_ON(ecc > USHORT_MAX);
+	BUG_ON(ecc > USHRT_MAX);
 
 	bc->bc_crc32e = cpu_to_le32(crc);
 	bc->bc_ecc = cpu_to_le16((u16)ecc);
diff -puN include/linux/kernel.h~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min include/linux/kernel.h
--- a/include/linux/kernel.h~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/include/linux/kernel.h
@@ -22,9 +22,9 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
-#define USHORT_MAX	((u16)(~0U))
-#define SHORT_MAX	((s16)(USHORT_MAX>>1))
-#define SHORT_MIN	(-SHORT_MAX - 1)
+#define USHRT_MAX	((u16)(~0U))
+#define SHRT_MAX	((s16)(USHRT_MAX>>1))
+#define SHRT_MIN	((s16)(-SHRT_MAX - 1))
 #define INT_MAX		((int)(~0U>>1))
 #define INT_MIN		(-INT_MAX - 1)
 #define UINT_MAX	(~0U)
diff -puN include/linux/sched.h~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min include/linux/sched.h
--- a/include/linux/sched.h~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/include/linux/sched.h
@@ -379,7 +379,7 @@ struct user_namespace;
  * 1-3 now and depends on arch. We use "5" as safe margin, here.
  */
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
-#define DEFAULT_MAX_MAP_COUNT	(USHORT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
+#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 
 extern int sysctl_max_map_count;
 
diff -puN include/net/ip.h~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min include/net/ip.h
--- a/include/net/ip.h~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/include/net/ip.h
@@ -352,11 +352,11 @@ enum ip_defrag_users {
 	IP_DEFRAG_LOCAL_DELIVER,
 	IP_DEFRAG_CALL_RA_CHAIN,
 	IP_DEFRAG_CONNTRACK_IN,
-	__IP_DEFRAG_CONNTRACK_IN_END	= IP_DEFRAG_CONNTRACK_IN + USHORT_MAX,
+	__IP_DEFRAG_CONNTRACK_IN_END	= IP_DEFRAG_CONNTRACK_IN + USHRT_MAX,
 	IP_DEFRAG_CONNTRACK_OUT,
-	__IP_DEFRAG_CONNTRACK_OUT_END	= IP_DEFRAG_CONNTRACK_OUT + USHORT_MAX,
+	__IP_DEFRAG_CONNTRACK_OUT_END	= IP_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
 	IP_DEFRAG_CONNTRACK_BRIDGE_IN,
-	__IP_DEFRAG_CONNTRACK_BRIDGE_IN = IP_DEFRAG_CONNTRACK_BRIDGE_IN + USHORT_MAX,
+	__IP_DEFRAG_CONNTRACK_BRIDGE_IN = IP_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
 	IP_DEFRAG_VS_IN,
 	IP_DEFRAG_VS_OUT,
 	IP_DEFRAG_VS_FWD
diff -puN include/net/ipv6.h~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min include/net/ipv6.h
--- a/include/net/ipv6.h~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/include/net/ipv6.h
@@ -354,11 +354,11 @@ struct inet_frag_queue;
 enum ip6_defrag_users {
 	IP6_DEFRAG_LOCAL_DELIVER,
 	IP6_DEFRAG_CONNTRACK_IN,
-	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + USHORT_MAX,
+	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + USHRT_MAX,
 	IP6_DEFRAG_CONNTRACK_OUT,
-	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHORT_MAX,
+	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
 	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
-	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHORT_MAX,
+	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
 };
 
 struct ip6_create_arg {
diff -puN ipc/msg.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min ipc/msg.c
--- a/ipc/msg.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/ipc/msg.c
@@ -345,19 +345,19 @@ copy_msqid_to_user(void __user *buf, str
 		out.msg_rtime		= in->msg_rtime;
 		out.msg_ctime		= in->msg_ctime;
 
-		if (in->msg_cbytes > USHORT_MAX)
-			out.msg_cbytes	= USHORT_MAX;
+		if (in->msg_cbytes > USHRT_MAX)
+			out.msg_cbytes	= USHRT_MAX;
 		else
 			out.msg_cbytes	= in->msg_cbytes;
 		out.msg_lcbytes		= in->msg_cbytes;
 
-		if (in->msg_qnum > USHORT_MAX)
-			out.msg_qnum	= USHORT_MAX;
+		if (in->msg_qnum > USHRT_MAX)
+			out.msg_qnum	= USHRT_MAX;
 		else
 			out.msg_qnum	= in->msg_qnum;
 
-		if (in->msg_qbytes > USHORT_MAX)
-			out.msg_qbytes	= USHORT_MAX;
+		if (in->msg_qbytes > USHRT_MAX)
+			out.msg_qbytes	= USHRT_MAX;
 		else
 			out.msg_qbytes	= in->msg_qbytes;
 		out.msg_lqbytes		= in->msg_qbytes;
diff -puN ipc/util.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min ipc/util.c
--- a/ipc/util.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/ipc/util.c
@@ -124,8 +124,8 @@ void ipc_init_ids(struct ipc_ids *ids)
 	ids->seq = 0;
 	{
 		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
-		if (seq_limit > USHORT_MAX)
-			ids->seq_max = USHORT_MAX;
+		if (seq_limit > USHRT_MAX)
+			ids->seq_max = USHRT_MAX;
 		 else
 		 	ids->seq_max = seq_limit;
 	}
diff -puN lib/vsprintf.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min lib/vsprintf.c
--- a/lib/vsprintf.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/lib/vsprintf.c
@@ -1979,7 +1979,7 @@ int vsscanf(const char *buf, const char 
 		{
 			char *s = (char *)va_arg(args, char *);
 			if (field_width == -1)
-				field_width = SHORT_MAX;
+				field_width = SHRT_MAX;
 			/* first, skip leading white space in buffer */
 			str = skip_spaces(str);
 
diff -puN net/9p/protocol.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min net/9p/protocol.c
--- a/net/9p/protocol.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/net/9p/protocol.c
@@ -394,7 +394,7 @@ p9pdu_vwritef(struct p9_fcall *pdu, int 
 				const char *sptr = va_arg(ap, const char *);
 				int16_t len = 0;
 				if (sptr)
-					len = MIN(strlen(sptr), USHORT_MAX);
+					len = MIN(strlen(sptr), USHRT_MAX);
 
 				errcode = p9pdu_writef(pdu, proto_version,
 								"w", len);
diff -puN net/dccp/options.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min net/dccp/options.c
--- a/net/dccp/options.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/net/dccp/options.c
@@ -296,7 +296,7 @@ static inline u8 dccp_ndp_len(const u64 
 {
 	if (likely(ndp <= 0xFF))
 		return 1;
-	return likely(ndp <= USHORT_MAX) ? 2 : (ndp <= UINT_MAX ? 4 : 6);
+	return likely(ndp <= USHRT_MAX) ? 2 : (ndp <= UINT_MAX ? 4 : 6);
 }
 
 int dccp_insert_option(struct sock *sk, struct sk_buff *skb,
diff -puN net/ipv4/udp.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min net/ipv4/udp.c
--- a/net/ipv4/udp.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/net/ipv4/udp.c
@@ -1676,8 +1676,8 @@ int udp_lib_setsockopt(struct sock *sk, 
 			return -ENOPROTOOPT;
 		if (val != 0 && val < 8) /* Illegal coverage: use default (8) */
 			val = 8;
-		else if (val > USHORT_MAX)
-			val = USHORT_MAX;
+		else if (val > USHRT_MAX)
+			val = USHRT_MAX;
 		up->pcslen = val;
 		up->pcflag |= UDPLITE_SEND_CC;
 		break;
@@ -1690,8 +1690,8 @@ int udp_lib_setsockopt(struct sock *sk, 
 			return -ENOPROTOOPT;
 		if (val != 0 && val < 8) /* Avoid silly minimal values.       */
 			val = 8;
-		else if (val > USHORT_MAX)
-			val = USHORT_MAX;
+		else if (val > USHRT_MAX)
+			val = USHRT_MAX;
 		up->pcrlen = val;
 		up->pcflag |= UDPLITE_RECV_CC;
 		break;
diff -puN net/mac80211/sta_info.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min net/mac80211/sta_info.c
--- a/net/mac80211/sta_info.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/net/mac80211/sta_info.c
@@ -259,7 +259,7 @@ struct sta_info *sta_info_alloc(struct i
 	skb_queue_head_init(&sta->tx_filtered);
 
 	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-		sta->last_seq_ctrl[i] = cpu_to_le16(USHORT_MAX);
+		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Allocated STA %pM\n",
diff -puN net/sunrpc/rpcb_clnt.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min net/sunrpc/rpcb_clnt.c
--- a/net/sunrpc/rpcb_clnt.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min
+++ a/net/sunrpc/rpcb_clnt.c
@@ -783,7 +783,7 @@ static int rpcb_dec_getport(struct rpc_r
 	port = ntohl(*p);
 	dprintk("RPC: %5u PMAP_%s result: %lu\n", task->tk_pid,
 			task->tk_msg.rpc_proc->p_name, port);
-	if (unlikely(port > USHORT_MAX))
+	if (unlikely(port > USHRT_MAX))
 		return -EIO;
 
 	rpcb->r_port = port;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch
mpt-fusion-convert-to-seq_file.patch
errh-add-__must_check-to-error-pointer-handlers.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc-make-collect_sigign_sigcatch-rcu-safe.patch
proc-make-task_sig-lockless.patch
proc-turn-signal_struct-count-into-int-nr_threads.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch

