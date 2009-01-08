From: akpm@linux-foundation.org
Subject: - remove-lots-of-double-semicolons.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:07 -0800
Message-ID: <200901082251.n08Mp7UM030254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333AbZAHWvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fcarrijo@yahoo.com.br, casey@schaufler-ca.com, davem@davemloft.net, jmorris@namei.org, mfasheh@suse.com, mingo@elte.hu, tglx@linutronix.de, tiwai@suse.de, tytso@mit.edu, mm-commits@vg


The patch titled
     remove lots of double-semicolons
has been removed from the -mm tree.  Its filename was
     remove-lots-of-double-semicolons.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove lots of double-semicolons
From: Fernando Carrijo <fcarrijo@yahoo.com.br>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Acked-by: Mark Fasheh <mfasheh@suse.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/longhaul.c |    2 +-
 fs/ocfs2/alloc.c                       |    2 +-
 fs/ocfs2/file.c                        |    2 +-
 net/ipv6/route.c                       |    2 +-
 net/ipv6/sysctl_net_ipv6.c             |    2 +-
 net/sched/sch_sfq.c                    |    2 +-
 security/smack/smackfs.c               |    2 +-
 sound/soc/au1x/dbdma2.c                |    2 +-
 sound/soc/davinci/davinci-pcm.c        |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/longhaul.c~remove-lots-of-double-semicolons arch/x86/kernel/cpu/cpufreq/longhaul.c
--- a/arch/x86/kernel/cpu/cpufreq/longhaul.c~remove-lots-of-double-semicolons
+++ a/arch/x86/kernel/cpu/cpufreq/longhaul.c
@@ -982,7 +982,7 @@ static int __init longhaul_init(void)
 	case 10:
 		printk(KERN_ERR PFX "Use acpi-cpufreq driver for VIA C7\n");
 	default:
-		;;
+		;
 	}
 
 	return -ENODEV;
diff -puN fs/ocfs2/alloc.c~remove-lots-of-double-semicolons fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~remove-lots-of-double-semicolons
+++ a/fs/ocfs2/alloc.c
@@ -3868,7 +3868,7 @@ static void ocfs2_split_record(struct in
 	struct ocfs2_extent_list *left_el = NULL, *right_el, *insert_el, *el;
 	struct ocfs2_extent_rec *rec, *tmprec;
 
-	right_el = path_leaf_el(right_path);;
+	right_el = path_leaf_el(right_path);
 	if (left_path)
 		left_el = path_leaf_el(left_path);
 
diff -puN fs/ocfs2/file.c~remove-lots-of-double-semicolons fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~remove-lots-of-double-semicolons
+++ a/fs/ocfs2/file.c
@@ -1605,7 +1605,7 @@ int ocfs2_change_file_space(struct file 
 			    struct ocfs2_space_resv *sr)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
 	    !ocfs2_writes_unwritten_extents(osb))
diff -puN net/ipv6/route.c~remove-lots-of-double-semicolons net/ipv6/route.c
--- a/net/ipv6/route.c~remove-lots-of-double-semicolons
+++ a/net/ipv6/route.c
@@ -2752,7 +2752,7 @@ int __init ip6_route_init(void)
 		kmem_cache_create("ip6_dst_cache", sizeof(struct rt6_info), 0,
 				  SLAB_HWCACHE_ALIGN, NULL);
 	if (!ip6_dst_ops_template.kmem_cachep)
-		goto out;;
+		goto out;
 
 	ret = register_pernet_subsys(&ip6_route_net_ops);
 	if (ret)
diff -puN net/ipv6/sysctl_net_ipv6.c~remove-lots-of-double-semicolons net/ipv6/sysctl_net_ipv6.c
--- a/net/ipv6/sysctl_net_ipv6.c~remove-lots-of-double-semicolons
+++ a/net/ipv6/sysctl_net_ipv6.c
@@ -128,7 +128,7 @@ static struct ctl_table_header *ip6_head
 
 int ipv6_sysctl_register(void)
 {
-	int err = -ENOMEM;;
+	int err = -ENOMEM;
 
 	ip6_header = register_net_sysctl_rotable(net_ipv6_ctl_path, ipv6_table);
 	if (ip6_header == NULL)
diff -puN net/sched/sch_sfq.c~remove-lots-of-double-semicolons net/sched/sch_sfq.c
--- a/net/sched/sch_sfq.c~remove-lots-of-double-semicolons
+++ a/net/sched/sch_sfq.c
@@ -435,7 +435,7 @@ static int sfq_init(struct Qdisc *sch, s
 	int i;
 
 	q->perturb_timer.function = sfq_perturbation;
-	q->perturb_timer.data = (unsigned long)sch;;
+	q->perturb_timer.data = (unsigned long)sch;
 	init_timer_deferrable(&q->perturb_timer);
 
 	for (i = 0; i < SFQ_HASH_DIVISOR; i++)
diff -puN security/smack/smackfs.c~remove-lots-of-double-semicolons security/smack/smackfs.c
--- a/security/smack/smackfs.c~remove-lots-of-double-semicolons
+++ a/security/smack/smackfs.c
@@ -569,7 +569,7 @@ static ssize_t smk_write_cipso(struct fi
 	if (skp == NULL)
 		goto out;
 
-	rule += SMK_LABELLEN;;
+	rule += SMK_LABELLEN;
 	ret = sscanf(rule, "%d", &maplevel);
 	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
 		goto out;
diff -puN sound/soc/au1x/dbdma2.c~remove-lots-of-double-semicolons sound/soc/au1x/dbdma2.c
--- a/sound/soc/au1x/dbdma2.c~remove-lots-of-double-semicolons
+++ a/sound/soc/au1x/dbdma2.c
@@ -187,7 +187,7 @@ static int au1x_pcm_dbdma_realloc(struct
 					au1x_pcm_dmatx_cb, (void *)pcd);
 
 	if (!pcd->ddma_chan)
-		return -ENOMEM;;
+		return -ENOMEM;
 
 	au1xxx_dbdma_set_devwidth(pcd->ddma_chan, msbits);
 	au1xxx_dbdma_ring_alloc(pcd->ddma_chan, 2);
diff -puN sound/soc/davinci/davinci-pcm.c~remove-lots-of-double-semicolons sound/soc/davinci/davinci-pcm.c
--- a/sound/soc/davinci/davinci-pcm.c~remove-lots-of-double-semicolons
+++ a/sound/soc/davinci/davinci-pcm.c
@@ -212,7 +212,7 @@ davinci_pcm_pointer(struct snd_pcm_subst
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		count = src - runtime->dma_addr;
 	else
-		count = dst - runtime->dma_addr;;
+		count = dst - runtime->dma_addr;
 
 	spin_unlock(&prtd->lock);
 
_

Patches currently in -mm which might be from fcarrijo@yahoo.com.br are

origin.patch

