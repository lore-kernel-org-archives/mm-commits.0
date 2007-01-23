From: akpm@osdl.org
Subject: + mark-struct-file_operations-const-9.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:32:15 -0800
Message-ID: <200701231932.l0NJWFq6029002@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50779 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933135AbXAWTcV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:32:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     mark struct file_operations const 9
has been added to the -mm tree.  Its filename is
     mark-struct-file_operations-const-9.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark struct file_operations const 9
From: Arjan van de Ven <arjan@linux.intel.com>

Many struct file_operations in the kernel can be "const".  Marking them const
moves these to the .rodata section, which avoids false sharing with potential
dirty data.  In addition it'll catch accidental writes at compile time to
these shared resources.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/platforms/cell/spufs/spufs.h |    2 -
 drivers/s390/char/tape_class.c            |    2 -
 drivers/s390/char/tape_class.h            |    2 -
 security/inode.c                          |    4 +--
 security/keys/proc.c                      |    4 +--
 security/selinux/selinuxfs.c              |   26 ++++++++++----------
 sound/core/control.c                      |    2 -
 sound/core/hwdep.c                        |    2 -
 sound/core/info.c                         |    2 -
 sound/core/init.c                         |    4 +--
 sound/core/oss/mixer_oss.c                |    2 -
 sound/core/oss/pcm_oss.c                  |    2 -
 sound/core/pcm_native.c                   |    2 -
 sound/core/rawmidi.c                      |    2 -
 sound/core/seq/oss/seq_oss.c              |    2 -
 sound/core/seq/seq_clientmgr.c            |    2 -
 sound/core/sound.c                        |    2 -
 sound/core/timer.c                        |    2 -
 sound/oss/ad1889.c                        |    4 +--
 sound/oss/btaudio.c                       |    6 ++--
 sound/oss/dmasound/dmasound_core.c        |    6 ++--
 sound/oss/emu10k1/audio.c                 |    2 -
 sound/oss/emu10k1/midi.c                  |    2 -
 sound/oss/emu10k1/mixer.c                 |    2 -
 sound/oss/hal2.c                          |    4 +--
 sound/oss/msnd_pinnacle.c                 |    2 -
 sound/oss/os.h                            |    2 -
 sound/oss/sh_dac_audio.c                  |    2 -
 sound/oss/soundcard.c                     |    2 -
 sound/oss/via82cxxx_audio.c               |    4 +--
 sound/oss/vwsnd.c                         |    4 +--
 sound/sound_core.c                        |    2 -
 32 files changed, 55 insertions(+), 55 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/spufs.h~mark-struct-file_operations-const-9 arch/powerpc/platforms/cell/spufs/spufs.h
--- a/arch/powerpc/platforms/cell/spufs/spufs.h~mark-struct-file_operations-const-9
+++ a/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -149,7 +149,7 @@ long spufs_run_spu(struct file *file,
 		   struct spu_context *ctx, u32 *npc, u32 *status);
 long spufs_create(struct nameidata *nd,
 			 unsigned int flags, mode_t mode);
-extern struct file_operations spufs_context_fops;
+extern const struct file_operations spufs_context_fops;
 
 /* gang management */
 struct spu_gang *alloc_spu_gang(void);
diff -puN drivers/s390/char/tape_class.c~mark-struct-file_operations-const-9 drivers/s390/char/tape_class.c
--- a/drivers/s390/char/tape_class.c~mark-struct-file_operations-const-9
+++ a/drivers/s390/char/tape_class.c
@@ -36,7 +36,7 @@ static struct class *tape_class;
 struct tape_class_device *register_tape_dev(
 	struct device *		device,
 	dev_t			dev,
-	struct file_operations *fops,
+	const struct file_operations *fops,
 	char *			device_name,
 	char *			mode_name)
 {
diff -puN drivers/s390/char/tape_class.h~mark-struct-file_operations-const-9 drivers/s390/char/tape_class.h
--- a/drivers/s390/char/tape_class.h~mark-struct-file_operations-const-9
+++ a/drivers/s390/char/tape_class.h
@@ -52,7 +52,7 @@ struct tape_class_device {
 struct tape_class_device *register_tape_dev(
 	struct device *		device,
 	dev_t			dev,
-	struct file_operations *fops,
+	const struct file_operations *fops,
 	char *			device_name,
 	char *			node_name
 );
diff -puN security/inode.c~mark-struct-file_operations-const-9 security/inode.c
--- a/security/inode.c~mark-struct-file_operations-const-9
+++ a/security/inode.c
@@ -50,7 +50,7 @@ static int default_open(struct inode *in
 	return 0;
 }
 
-static struct file_operations default_file_ops = {
+static const struct file_operations default_file_ops = {
 	.read =		default_read_file,
 	.write =	default_write_file,
 	.open =		default_open,
@@ -215,7 +215,7 @@ static int create_by_name(const char *na
  */
 struct dentry *securityfs_create_file(const char *name, mode_t mode,
 				   struct dentry *parent, void *data,
-				   struct file_operations *fops)
+				   const struct file_operations *fops)
 {
 	struct dentry *dentry = NULL;
 	int error;
diff -puN security/keys/proc.c~mark-struct-file_operations-const-9 security/keys/proc.c
--- a/security/keys/proc.c~mark-struct-file_operations-const-9
+++ a/security/keys/proc.c
@@ -33,7 +33,7 @@ static struct seq_operations proc_keys_o
 	.show	= proc_keys_show,
 };
 
-static struct file_operations proc_keys_fops = {
+static const struct file_operations proc_keys_fops = {
 	.open		= proc_keys_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -54,7 +54,7 @@ static struct seq_operations proc_key_us
 	.show	= proc_key_users_show,
 };
 
-static struct file_operations proc_key_users_fops = {
+static const struct file_operations proc_key_users_fops = {
 	.open		= proc_key_users_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN security/selinux/selinuxfs.c~mark-struct-file_operations-const-9 security/selinux/selinuxfs.c
--- a/security/selinux/selinuxfs.c~mark-struct-file_operations-const-9
+++ a/security/selinux/selinuxfs.c
@@ -161,7 +161,7 @@ out:
 #define sel_write_enforce NULL
 #endif
 
-static struct file_operations sel_enforce_ops = {
+static const struct file_operations sel_enforce_ops = {
 	.read		= sel_read_enforce,
 	.write		= sel_write_enforce,
 };
@@ -211,7 +211,7 @@ out:
 #define sel_write_disable NULL
 #endif
 
-static struct file_operations sel_disable_ops = {
+static const struct file_operations sel_disable_ops = {
 	.write		= sel_write_disable,
 };
 
@@ -225,7 +225,7 @@ static ssize_t sel_read_policyvers(struc
 	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
 }
 
-static struct file_operations sel_policyvers_ops = {
+static const struct file_operations sel_policyvers_ops = {
 	.read		= sel_read_policyvers,
 };
 
@@ -242,7 +242,7 @@ static ssize_t sel_read_mls(struct file 
 	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
 }
 
-static struct file_operations sel_mls_ops = {
+static const struct file_operations sel_mls_ops = {
 	.read		= sel_read_mls,
 };
 
@@ -294,7 +294,7 @@ out:
 	return length;
 }
 
-static struct file_operations sel_load_ops = {
+static const struct file_operations sel_load_ops = {
 	.write		= sel_write_load,
 };
 
@@ -374,7 +374,7 @@ out:
 	free_page((unsigned long) page);
 	return length;
 }
-static struct file_operations sel_checkreqprot_ops = {
+static const struct file_operations sel_checkreqprot_ops = {
 	.read		= sel_read_checkreqprot,
 	.write		= sel_write_checkreqprot,
 };
@@ -423,7 +423,7 @@ out:
 	free_page((unsigned long) page);
 	return length;
 }
-static struct file_operations sel_compat_net_ops = {
+static const struct file_operations sel_compat_net_ops = {
 	.read		= sel_read_compat_net,
 	.write		= sel_write_compat_net,
 };
@@ -467,7 +467,7 @@ static ssize_t selinux_transaction_write
 	return rv;
 }
 
-static struct file_operations transaction_ops = {
+static const struct file_operations transaction_ops = {
 	.write		= selinux_transaction_write,
 	.read		= simple_transaction_read,
 	.release	= simple_transaction_release,
@@ -875,7 +875,7 @@ out:
 	return length;
 }
 
-static struct file_operations sel_bool_ops = {
+static const struct file_operations sel_bool_ops = {
 	.read           = sel_read_bool,
 	.write          = sel_write_bool,
 };
@@ -932,7 +932,7 @@ out:
 	return length;
 }
 
-static struct file_operations sel_commit_bools_ops = {
+static const struct file_operations sel_commit_bools_ops = {
 	.write          = sel_commit_bools_write,
 };
 
@@ -1131,12 +1131,12 @@ out:
 	return ret;
 }
 
-static struct file_operations sel_avc_cache_threshold_ops = {
+static const struct file_operations sel_avc_cache_threshold_ops = {
 	.read		= sel_read_avc_cache_threshold,
 	.write		= sel_write_avc_cache_threshold,
 };
 
-static struct file_operations sel_avc_hash_stats_ops = {
+static const struct file_operations sel_avc_hash_stats_ops = {
 	.read		= sel_read_avc_hash_stats,
 };
 
@@ -1198,7 +1198,7 @@ static int sel_open_avc_cache_stats(stru
 	return seq_open(file, &sel_avc_cache_stats_seq_ops);
 }
 
-static struct file_operations sel_avc_cache_stats_ops = {
+static const struct file_operations sel_avc_cache_stats_ops = {
 	.open		= sel_open_avc_cache_stats,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN sound/core/control.c~mark-struct-file_operations-const-9 sound/core/control.c
--- a/sound/core/control.c~mark-struct-file_operations-const-9
+++ a/sound/core/control.c
@@ -1398,7 +1398,7 @@ static int snd_ctl_fasync(int fd, struct
  *  INIT PART
  */
 
-static struct file_operations snd_ctl_f_ops =
+static const struct file_operations snd_ctl_f_ops =
 {
 	.owner =	THIS_MODULE,
 	.read =		snd_ctl_read,
diff -puN sound/core/hwdep.c~mark-struct-file_operations-const-9 sound/core/hwdep.c
--- a/sound/core/hwdep.c~mark-struct-file_operations-const-9
+++ a/sound/core/hwdep.c
@@ -316,7 +316,7 @@ static int snd_hwdep_control_ioctl(struc
 
  */
 
-static struct file_operations snd_hwdep_f_ops =
+static const struct file_operations snd_hwdep_f_ops =
 {
 	.owner = 	THIS_MODULE,
 	.llseek =	snd_hwdep_llseek,
diff -puN sound/core/info.c~mark-struct-file_operations-const-9 sound/core/info.c
--- a/sound/core/info.c~mark-struct-file_operations-const-9
+++ a/sound/core/info.c
@@ -507,7 +507,7 @@ static int snd_info_entry_mmap(struct fi
 	return -ENXIO;
 }
 
-static struct file_operations snd_info_entry_operations =
+static const struct file_operations snd_info_entry_operations =
 {
 	.owner =		THIS_MODULE,
 	.llseek =		snd_info_entry_llseek,
diff -puN sound/core/init.c~mark-struct-file_operations-const-9 sound/core/init.c
--- a/sound/core/init.c~mark-struct-file_operations-const-9
+++ a/sound/core/init.c
@@ -36,7 +36,7 @@
 static DEFINE_SPINLOCK(shutdown_lock);
 static LIST_HEAD(shutdown_files);
 
-static struct file_operations snd_shutdown_f_ops;
+static const struct file_operations snd_shutdown_f_ops;
 
 static unsigned int snd_cards_lock;	/* locked for registering/using */
 struct snd_card *snd_cards[SNDRV_CARDS];
@@ -244,7 +244,7 @@ static int snd_disconnect_fasync(int fd,
 	return -ENODEV;
 }
 
-static struct file_operations snd_shutdown_f_ops =
+static const struct file_operations snd_shutdown_f_ops =
 {
 	.owner = 	THIS_MODULE,
 	.llseek =	snd_disconnect_llseek,
diff -puN sound/core/oss/mixer_oss.c~mark-struct-file_operations-const-9 sound/core/oss/mixer_oss.c
--- a/sound/core/oss/mixer_oss.c~mark-struct-file_operations-const-9
+++ a/sound/core/oss/mixer_oss.c
@@ -390,7 +390,7 @@ int snd_mixer_oss_ioctl_card(struct snd_
  *  REGISTRATION PART
  */
 
-static struct file_operations snd_mixer_oss_f_ops =
+static const struct file_operations snd_mixer_oss_f_ops =
 {
 	.owner =	THIS_MODULE,
 	.open =		snd_mixer_oss_open,
diff -puN sound/core/oss/pcm_oss.c~mark-struct-file_operations-const-9 sound/core/oss/pcm_oss.c
--- a/sound/core/oss/pcm_oss.c~mark-struct-file_operations-const-9
+++ a/sound/core/oss/pcm_oss.c
@@ -2889,7 +2889,7 @@ static void snd_pcm_oss_proc_done(struct
  *  ENTRY functions
  */
 
-static struct file_operations snd_pcm_oss_f_reg =
+static const struct file_operations snd_pcm_oss_f_reg =
 {
 	.owner =	THIS_MODULE,
 	.read =		snd_pcm_oss_read,
diff -puN sound/core/pcm_native.c~mark-struct-file_operations-const-9 sound/core/pcm_native.c
--- a/sound/core/pcm_native.c~mark-struct-file_operations-const-9
+++ a/sound/core/pcm_native.c
@@ -3424,7 +3424,7 @@ out:
  *  Register section
  */
 
-struct file_operations snd_pcm_f_ops[2] = {
+const struct file_operations snd_pcm_f_ops[2] = {
 	{
 		.owner =		THIS_MODULE,
 		.write =		snd_pcm_write,
diff -puN sound/core/rawmidi.c~mark-struct-file_operations-const-9 sound/core/rawmidi.c
--- a/sound/core/rawmidi.c~mark-struct-file_operations-const-9
+++ a/sound/core/rawmidi.c
@@ -1359,7 +1359,7 @@ static void snd_rawmidi_proc_info_read(s
  *  Register functions
  */
 
-static struct file_operations snd_rawmidi_f_ops =
+static const struct file_operations snd_rawmidi_f_ops =
 {
 	.owner =	THIS_MODULE,
 	.read =		snd_rawmidi_read,
diff -puN sound/core/seq/oss/seq_oss.c~mark-struct-file_operations-const-9 sound/core/seq/oss/seq_oss.c
--- a/sound/core/seq/oss/seq_oss.c~mark-struct-file_operations-const-9
+++ a/sound/core/seq/oss/seq_oss.c
@@ -208,7 +208,7 @@ odev_poll(struct file *file, poll_table 
  * registration of sequencer minor device
  */
 
-static struct file_operations seq_oss_f_ops =
+static const struct file_operations seq_oss_f_ops =
 {
 	.owner =	THIS_MODULE,
 	.read =		odev_read,
diff -puN sound/core/seq/seq_clientmgr.c~mark-struct-file_operations-const-9 sound/core/seq/seq_clientmgr.c
--- a/sound/core/seq/seq_clientmgr.c~mark-struct-file_operations-const-9
+++ a/sound/core/seq/seq_clientmgr.c
@@ -2538,7 +2538,7 @@ void snd_seq_info_clients_read(struct sn
  *  REGISTRATION PART
  */
 
-static struct file_operations snd_seq_f_ops =
+static const struct file_operations snd_seq_f_ops =
 {
 	.owner =	THIS_MODULE,
 	.read =		snd_seq_read,
diff -puN sound/core/sound.c~mark-struct-file_operations-const-9 sound/core/sound.c
--- a/sound/core/sound.c~mark-struct-file_operations-const-9
+++ a/sound/core/sound.c
@@ -168,7 +168,7 @@ static int snd_open(struct inode *inode,
 	return err;
 }
 
-static struct file_operations snd_fops =
+static const struct file_operations snd_fops =
 {
 	.owner =	THIS_MODULE,
 	.open =		snd_open
diff -puN sound/core/timer.c~mark-struct-file_operations-const-9 sound/core/timer.c
--- a/sound/core/timer.c~mark-struct-file_operations-const-9
+++ a/sound/core/timer.c
@@ -1904,7 +1904,7 @@ static unsigned int snd_timer_user_poll(
 #define snd_timer_user_ioctl_compat	NULL
 #endif
 
-static struct file_operations snd_timer_f_ops =
+static const struct file_operations snd_timer_f_ops =
 {
 	.owner =	THIS_MODULE,
 	.read =		snd_timer_user_read,
diff -puN sound/oss/ad1889.c~mark-struct-file_operations-const-9 sound/oss/ad1889.c
--- a/sound/oss/ad1889.c~mark-struct-file_operations-const-9
+++ a/sound/oss/ad1889.c
@@ -777,7 +777,7 @@ static int ad1889_release(struct inode *
 	return 0;
 }
 
-static struct file_operations ad1889_fops = {
+static const struct file_operations ad1889_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= ad1889_read,
@@ -811,7 +811,7 @@ static int ad1889_mixer_ioctl(struct ino
 	return codec->mixer_ioctl(codec, cmd, arg);
 }
 
-static struct file_operations ad1889_mixer_fops = {
+static const struct file_operations ad1889_mixer_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.ioctl		= ad1889_mixer_ioctl,
diff -puN sound/oss/btaudio.c~mark-struct-file_operations-const-9 sound/oss/btaudio.c
--- a/sound/oss/btaudio.c~mark-struct-file_operations-const-9
+++ a/sound/oss/btaudio.c
@@ -429,7 +429,7 @@ static int btaudio_mixer_ioctl(struct in
 	return 0;
 }
 
-static struct file_operations btaudio_mixer_fops = {
+static const struct file_operations btaudio_mixer_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.open		= btaudio_mixer_open,
@@ -796,7 +796,7 @@ static unsigned int btaudio_dsp_poll(str
 	return mask;
 }
 
-static struct file_operations btaudio_digital_dsp_fops = {
+static const struct file_operations btaudio_digital_dsp_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.open		= btaudio_dsp_open_digital,
@@ -807,7 +807,7 @@ static struct file_operations btaudio_di
 	.poll		= btaudio_dsp_poll,
 };
 
-static struct file_operations btaudio_analog_dsp_fops = {
+static const struct file_operations btaudio_analog_dsp_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.open		= btaudio_dsp_open_analog,
diff -puN sound/oss/dmasound/dmasound_core.c~mark-struct-file_operations-const-9 sound/oss/dmasound/dmasound_core.c
--- a/sound/oss/dmasound/dmasound_core.c~mark-struct-file_operations-const-9
+++ a/sound/oss/dmasound/dmasound_core.c
@@ -371,7 +371,7 @@ static int mixer_ioctl(struct inode *ino
 	return -EINVAL;
 }
 
-static struct file_operations mixer_fops =
+static const struct file_operations mixer_fops =
 {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
@@ -1337,7 +1337,7 @@ static int sq_ioctl(struct inode *inode,
 	return -EINVAL;
 }
 
-static struct file_operations sq_fops =
+static const struct file_operations sq_fops =
 {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
@@ -1561,7 +1561,7 @@ static ssize_t state_read(struct file *f
 	return n;
 }
 
-static struct file_operations state_fops = {
+static const struct file_operations state_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= state_read,
diff -puN sound/oss/emu10k1/audio.c~mark-struct-file_operations-const-9 sound/oss/emu10k1/audio.c
--- a/sound/oss/emu10k1/audio.c~mark-struct-file_operations-const-9
+++ a/sound/oss/emu10k1/audio.c
@@ -1582,7 +1582,7 @@ static void emu10k1_waveout_bh(unsigned 
 	return;
 }
 
-struct file_operations emu10k1_audio_fops = {
+const struct file_operations emu10k1_audio_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= emu10k1_audio_read,
diff -puN sound/oss/emu10k1/midi.c~mark-struct-file_operations-const-9 sound/oss/emu10k1/midi.c
--- a/sound/oss/emu10k1/midi.c~mark-struct-file_operations-const-9
+++ a/sound/oss/emu10k1/midi.c
@@ -458,7 +458,7 @@ int emu10k1_midi_callback(unsigned long 
 }
 
 /* MIDI file operations */
-struct file_operations emu10k1_midi_fops = {
+const struct file_operations emu10k1_midi_fops = {
 	.owner		= THIS_MODULE,
 	.read		= emu10k1_midi_read,
 	.write		= emu10k1_midi_write,
diff -puN sound/oss/emu10k1/mixer.c~mark-struct-file_operations-const-9 sound/oss/emu10k1/mixer.c
--- a/sound/oss/emu10k1/mixer.c~mark-struct-file_operations-const-9
+++ a/sound/oss/emu10k1/mixer.c
@@ -681,7 +681,7 @@ static int emu10k1_mixer_release(struct 
 	return 0;
 }
 
-struct file_operations emu10k1_mixer_fops = {
+const struct file_operations emu10k1_mixer_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.ioctl		= emu10k1_mixer_ioctl,
diff -puN sound/oss/hal2.c~mark-struct-file_operations-const-9 sound/oss/hal2.c
--- a/sound/oss/hal2.c~mark-struct-file_operations-const-9
+++ a/sound/oss/hal2.c
@@ -1377,7 +1377,7 @@ static int hal2_release(struct inode *in
 	return 0;
 }
 
-static struct file_operations hal2_audio_fops = {
+static const struct file_operations hal2_audio_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= hal2_read,
@@ -1388,7 +1388,7 @@ static struct file_operations hal2_audio
 	.release	= hal2_release,
 };
 
-static struct file_operations hal2_mixer_fops = {
+static const struct file_operations hal2_mixer_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.ioctl		= hal2_ioctl_mixdev,
diff -puN sound/oss/msnd_pinnacle.c~mark-struct-file_operations-const-9 sound/oss/msnd_pinnacle.c
--- a/sound/oss/msnd_pinnacle.c~mark-struct-file_operations-const-9
+++ a/sound/oss/msnd_pinnacle.c
@@ -1106,7 +1106,7 @@ static irqreturn_t intr(int irq, void *d
 	return IRQ_HANDLED;
 }
 
-static struct file_operations dev_fileops = {
+static const struct file_operations dev_fileops = {
 	.owner		= THIS_MODULE,
 	.read		= dev_read,
 	.write		= dev_write,
diff -puN sound/oss/os.h~mark-struct-file_operations-const-9 sound/oss/os.h
--- a/sound/oss/os.h~mark-struct-file_operations-const-9
+++ a/sound/oss/os.h
@@ -43,4 +43,4 @@ extern int sound_nblocks;
 #undef PSEUDO_DMA_AUTOINIT
 #define ALLOW_BUFFER_MAPPING
 
-extern struct file_operations oss_sound_fops;
+extern const struct file_operations oss_sound_fops;
diff -puN sound/oss/sh_dac_audio.c~mark-struct-file_operations-const-9 sound/oss/sh_dac_audio.c
--- a/sound/oss/sh_dac_audio.c~mark-struct-file_operations-const-9
+++ a/sound/oss/sh_dac_audio.c
@@ -255,7 +255,7 @@ static int dac_audio_release(struct inod
 	return 0;
 }
 
-struct file_operations dac_audio_fops = {
+const struct file_operations dac_audio_fops = {
       .read =		dac_audio_read,
       .write =	dac_audio_write,
       .ioctl =	dac_audio_ioctl,
diff -puN sound/oss/soundcard.c~mark-struct-file_operations-const-9 sound/oss/soundcard.c
--- a/sound/oss/soundcard.c~mark-struct-file_operations-const-9
+++ a/sound/oss/soundcard.c
@@ -482,7 +482,7 @@ static int sound_mmap(struct file *file,
 	return 0;
 }
 
-struct file_operations oss_sound_fops = {
+const struct file_operations oss_sound_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= sound_read,
diff -puN sound/oss/via82cxxx_audio.c~mark-struct-file_operations-const-9 sound/oss/via82cxxx_audio.c
--- a/sound/oss/via82cxxx_audio.c~mark-struct-file_operations-const-9
+++ a/sound/oss/via82cxxx_audio.c
@@ -1619,7 +1619,7 @@ out:
 }
 
 
-static struct file_operations via_mixer_fops = {
+static const struct file_operations via_mixer_fops = {
 	.owner		= THIS_MODULE,
 	.open		= via_mixer_open,
 	.llseek		= no_llseek,
@@ -2042,7 +2042,7 @@ static int via_interrupt_init (struct vi
  *
  */
 
-static struct file_operations via_dsp_fops = {
+static const struct file_operations via_dsp_fops = {
 	.owner		= THIS_MODULE,
 	.open		= via_dsp_open,
 	.release	= via_dsp_release,
diff -puN sound/oss/vwsnd.c~mark-struct-file_operations-const-9 sound/oss/vwsnd.c
--- a/sound/oss/vwsnd.c~mark-struct-file_operations-const-9
+++ a/sound/oss/vwsnd.c
@@ -3035,7 +3035,7 @@ static int vwsnd_audio_release(struct in
 	return err;
 }
 
-static struct file_operations vwsnd_audio_fops = {
+static const struct file_operations vwsnd_audio_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.read =		vwsnd_audio_read,
@@ -3225,7 +3225,7 @@ static int vwsnd_mixer_ioctl(struct inod
 	return retval;
 }
 
-static struct file_operations vwsnd_mixer_fops = {
+static const struct file_operations vwsnd_mixer_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.ioctl =	vwsnd_mixer_ioctl,
diff -puN sound/sound_core.c~mark-struct-file_operations-const-9 sound/sound_core.c
--- a/sound/sound_core.c~mark-struct-file_operations-const-9
+++ a/sound/sound_core.c
@@ -436,7 +436,7 @@ EXPORT_SYMBOL(unregister_sound_dsp);
 
 static int soundcore_open(struct inode *, struct file *);
 
-static struct file_operations soundcore_fops=
+static const struct file_operations soundcore_fops=
 {
 	/* We must have an owner or the module locking fails */
 	.owner	= THIS_MODULE,
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-libata-all.patch
git-netdev-all.patch
user-of-the-jiffies-rounding-code-networking.patch
mmconfig-cleanup.patch
mmconfig-fix-unreachable_devices.patch
mark-struct-file_operations-const-1.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-3.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-5.patch
mark-struct-file_operations-const-6.patch
mark-struct-file_operations-const-7.patch
mark-struct-file_operations-const-8.patch
mark-struct-file_operations-const-9.patch
mark-struct-inode_operations-const-1.patch
mark-struct-inode_operations-const-2.patch
mark-struct-inode_operations-const-3.patch
