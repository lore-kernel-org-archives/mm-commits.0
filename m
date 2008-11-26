From: akpm@linux-foundation.org
Subject: + remove-lots-of-double-semicolons.patch added to -mm tree
Date: Wed, 26 Nov 2008 14:53:44 -0800
Message-ID: <200811262253.mAQMrir3013754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbYKZWyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 17:54:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fcarrijo@yahoo.com.br, casey@schaufler-ca.com, davem@davemloft.net, jmorris@namei.org, mfasheh@suse.com, mingo@elte.hu, tglx@linutronix.de, tiwai@suse.de, tytso@mit.edu


The patch titled
     remove lots of double-semicolons
has been added to the -mm tree.  Its filename is
     remove-lots-of-double-semicolons.patch

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
Subject: remove lots of double-semicolons
From: Fernando Carrijo <fcarrijo@yahoo.com.br>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/longhaul.c |    2 +-
 arch/x86/kernel/ptrace.c               |    2 +-
 fs/ext4/mballoc.c                      |    4 ++--
 fs/ocfs2/alloc.c                       |    2 +-
 fs/ocfs2/file.c                        |    2 +-
 net/ipv6/route.c                       |    2 +-
 net/ipv6/sysctl_net_ipv6.c             |    2 +-
 net/sched/sch_sfq.c                    |    2 +-
 security/smack/smackfs.c               |    2 +-
 sound/soc/au1x/dbdma2.c                |    2 +-
 sound/soc/davinci/davinci-pcm.c        |    2 +-
 11 files changed, 12 insertions(+), 12 deletions(-)

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
diff -puN arch/x86/kernel/ptrace.c~remove-lots-of-double-semicolons arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~remove-lots-of-double-semicolons
+++ a/arch/x86/kernel/ptrace.c
@@ -637,7 +637,7 @@ static inline unsigned long bts_get(cons
 
 static inline void bts_set(char *base, enum bts_field field, unsigned long val)
 {
-	base += (bts_cfg.sizeof_field * field);;
+	base += (bts_cfg.sizeof_field * field);
 	(*(unsigned long *)base) = val;
 }
 
diff -puN fs/ext4/mballoc.c~remove-lots-of-double-semicolons fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~remove-lots-of-double-semicolons
+++ a/fs/ext4/mballoc.c
@@ -2086,7 +2086,7 @@ static void *ext4_mb_seq_groups_next(str
 	if (*pos < 0 || *pos >= sbi->s_groups_count)
 		return NULL;
 	group = *pos + 1;
-	return (void *) group;;
+	return (void *) group;
 }
 
 static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
@@ -2300,7 +2300,7 @@ int ext4_mb_add_groupinfo(struct super_b
 	}
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
-	meta_group_info[i]->bb_free_root.rb_node = NULL;;
+	meta_group_info[i]->bb_free_root.rb_node = NULL;
 
 #ifdef DOUBLE_CHECK
 	{
diff -puN fs/ocfs2/alloc.c~remove-lots-of-double-semicolons fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~remove-lots-of-double-semicolons
+++ a/fs/ocfs2/alloc.c
@@ -3781,7 +3781,7 @@ static void ocfs2_split_record(struct in
 	struct ocfs2_extent_list *left_el = NULL, *right_el, *insert_el, *el;
 	struct ocfs2_extent_rec *rec, *tmprec;
 
-	right_el = path_leaf_el(right_path);;
+	right_el = path_leaf_el(right_path);
 	if (left_path)
 		left_el = path_leaf_el(left_path);
 
diff -puN fs/ocfs2/file.c~remove-lots-of-double-semicolons fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~remove-lots-of-double-semicolons
+++ a/fs/ocfs2/file.c
@@ -1622,7 +1622,7 @@ int ocfs2_change_file_space(struct file 
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
@@ -2710,7 +2710,7 @@ int __init ip6_route_init(void)
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
@@ -541,7 +541,7 @@ static ssize_t smk_write_cipso(struct fi
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
@@ -218,7 +218,7 @@ davinci_pcm_pointer(struct snd_pcm_subst
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		count = src - runtime->dma_addr;
 	else
-		count = dst - runtime->dma_addr;;
+		count = dst - runtime->dma_addr;
 
 	spin_unlock(&prtd->lock);
 
_

Patches currently in -mm which might be from fcarrijo@yahoo.com.br are

remove-lots-of-double-semicolons.patch

