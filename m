From: akpm@linux-foundation.org
Subject: - oss-trident-massive-whitespace-removal.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:02 -0700
Message-ID: <200707172306.l6HN62f4011976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764208AbXGQXPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     OSS trident: massive whitespace removal
has been removed from the -mm tree.  Its filename was
     oss-trident-massive-whitespace-removal.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: OSS trident: massive whitespace removal
=46rom: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/trident.c |  358 +++++++++++++++++++++---------------------
 1 file changed, 179 insertions(+), 179 deletions(-)

diff -puN sound/oss/trident.c~oss-trident-massive-whitespace-removal so=
und/oss/trident.c
--- a/sound/oss/trident.c~oss-trident-massive-whitespace-removal
+++ a/sound/oss/trident.c
@@ -11,12 +11,12 @@
  *  Built from:
  *	Low level code: <audio@tridentmicro.com> from ALSA
  *	Framework: Thomas Sailer <sailer@ife.ee.ethz.ch>
- *	Extended by: Zach Brown <zab@redhat.com> =20
+ *	Extended by: Zach Brown <zab@redhat.com>
  *
  *  Hacked up by:
  *	Aaron Holtzman <aholtzma@ess.engr.uvic.ca>
  *	Ollie Lho <ollie@sis.com.tw> SiS 7018 Audio Core Support
- *	Ching-Ling Lee <cling-li@ali.com.tw> ALi 5451 Audio Core Support=20
+ *	Ching-Ling Lee <cling-li@ali.com.tw> ALi 5451 Audio Core Support
  *	Matt Wu <mattwu@acersoftech.com.cn> ALi 5451 Audio Core Support
  *	Peter W=C3=A4chtler <pwaechtler@loewe-komp.de> CyberPro5050 support
  *      Muli Ben-Yehuda <mulix@mulix.org>
@@ -54,33 +54,33 @@
  *	adapt to new pci joystick attachment interface
  *  v0.14.10f
  *      July 24 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
- *      patch from Eric Lemar (via Ian Soboroff): in suspend and resum=
e,=20
- *      fix wrong cast from pci_dev* to struct trident_card*.=20
+ *      patch from Eric Lemar (via Ian Soboroff): in suspend and resum=
e,
+ *      fix wrong cast from pci_dev* to struct trident_card*.
  *  v0.14.10e
  *      July 19 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
- *      rewrite the DMA buffer allocation/deallcoation functions, to m=
ake it=20
- *      modular and fix a bug where we would call free_pages on memory=
=20
- *      obtained with pci_alloc_consistent. Also remove unnecessary #i=
fdef=20
+ *      rewrite the DMA buffer allocation/deallcoation functions, to m=
ake it
+ *      modular and fix a bug where we would call free_pages on memory
+ *      obtained with pci_alloc_consistent. Also remove unnecessary #i=
fdef
  *      CONFIG_PROC_FS and various other cleanups.
  *  v0.14.10d
  *      July 19 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
  *      made several printk(KERN_NOTICE...) into TRDBG(...), to avoid =
spamming
- *      my syslog with hundreds of messages.=20
+ *      my syslog with hundreds of messages.
  *  v0.14.10c
  *      July 16 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
  *      Cleaned up Lei Hu's 0.4.10 driver to conform to Documentation/=
CodingStyle
- *      and the coding style used in the rest of the file.=20
+ *      and the coding style used in the rest of the file.
  *  v0.14.10b
  *      June 23 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
- *      add a missing unlock_set_fmt, remove a superflous lock/unlock =
pair=20
- *      with nothing in between.=20
+ *      add a missing unlock_set_fmt, remove a superflous lock/unlock =
pair
+ *      with nothing in between.
  *  v0.14.10a
- *      June 21 2002 Muli Ben-Yehuda <mulix@actcom.co.il>=20
- *      use a debug macro instead of #ifdef CONFIG_DEBUG, trim to 80 c=
olumns=20
- *      per line, use 'do {} while (0)' in statement macros.=20
+ *      June 21 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
+ *      use a debug macro instead of #ifdef CONFIG_DEBUG, trim to 80 c=
olumns
+ *      per line, use 'do {} while (0)' in statement macros.
  *  v0.14.10
  *      June 6 2002 Lei Hu <Lei_hu@ali.com.tw>
- *      rewrite the part to read/write registers of audio codec for Al=
i5451=20
+ *      rewrite the part to read/write registers of audio codec for Al=
i5451
  *  v0.14.9e
  *      January 2 2002 Vojtech Pavlik <vojtech@ucw.cz> added gameport
  *      support to avoid resource conflict with pcigame.c
@@ -111,7 +111,7 @@
  *	Set EBUF1 and EBUF2 to still mode
  *	Add dc97/ac97 reset function
  *	Fix power management: ali_restore_regs
- *  unreleased=20
+ *  unreleased
  *	Mar 09 2001 Matt Wu
  *	Add cache for ac97 access
  *  v0.14.7
@@ -120,7 +120,7 @@
  *	Fix bug: an extra tail will be played when playing
  *	Jan 05 2001 Matt Wu
  *	Implement multi-channels and S/PDIF in support for ALi 1535+
- *  v0.14.6=20
+ *  v0.14.6
  *	Nov 1 2000 Ching-Ling Lee
  *	Fix the bug of memory leak when switching 5.1-channels to 2 channel=
s.
  *	Add lock protection into dynamic changing format of data.
@@ -138,7 +138,7 @@
  *  v0.14.3 May 10 2000 Ollie Lho
  *	fixed a small bug in trident_update_ptr, xmms 1.0.1 no longer uses =
100% CPU
  *  v0.14.2 Mar 29 2000 Ching-Ling Lee
- *	Add clear to silence advance in trident_update_ptr=20
+ *	Add clear to silence advance in trident_update_ptr
  *	fix invalid data of the end of the sound
  *  v0.14.1 Mar 24 2000 Ching-Ling Lee
  *	ALi 5451 support added, playback and recording O.K.
@@ -178,7 +178,7 @@
  *	SiS 7018 support added, playback O.K.
  *  v0.01 Alan Cox et. al.
  *	Initial Release in kernel 2.3.30, does not work
- *=20
+ *
  *  ToDo
  *	Clean up of low level channel register access code. (done)
  *	Fix the bug on dma buffer management in update_ptr, read/write, dra=
in_dac (done)
@@ -326,7 +326,7 @@ struct trident_state {
=20
 		unsigned error;	/* number of over/underruns */
                 /* put process on wait queue when no more space in buf=
fer */
-		wait_queue_head_t wait;=09
+		wait_queue_head_t wait;
=20
 		/* redundant, but makes calculations easier */
 		unsigned fragsize;
@@ -358,7 +358,7 @@ struct trident_state {
 struct trident_channel {
 	int num; /* channel number */
 	u32 lba; /* Loop Begine Address, where dma buffer starts */
-	u32 eso; /* End Sample Offset, wehre dma buffer ends */=20
+	u32 eso; /* End Sample Offset, wehre dma buffer ends */
 	         /* (in the unit of samples) */
 	u32 delta; /* delta value, sample rate / 48k for playback, */
 	           /* 48k/sample rate for recording */
@@ -417,7 +417,7 @@ struct trident_card {
 	/* soundcore stuff */
 	int dev_audio;
=20
-	/* structures for abstraction of hardware facilities, codecs, */=20
+	/* structures for abstraction of hardware facilities, codecs, */
 	/* banks and channels */
 	struct ac97_codec *ac97_codec[NR_AC97];
 	struct trident_pcm_bank banks[NR_BANKS];
@@ -479,7 +479,7 @@ static void trident_ac97_set(struct ac97
 static u16 trident_ac97_get(struct ac97_codec *codec, u8 reg);
=20
 static int trident_open_mixdev(struct inode *inode, struct file *file)=
;
-static int trident_ioctl_mixdev(struct inode *inode, struct file *file=
,=20
+static int trident_ioctl_mixdev(struct inode *inode, struct file *file=
,
 				unsigned int cmd, unsigned long arg);
=20
 static void ali_ac97_set(struct trident_card *card, int secondary, u8 =
reg, u16 val);
@@ -496,10 +496,10 @@ static void ali_disable_spdif_in(struct=20
 static void ali_disable_special_channel(struct trident_card *card, int=
 ch);
 static void ali_setup_spdif_out(struct trident_card *card, int flag);
 static int ali_write_5_1(struct trident_state *state,
-			 const char __user *buffer,=20
-			 int cnt_for_multi_channel, unsigned int *copy_count,=20
+			 const char __user *buffer,
+			 int cnt_for_multi_channel, unsigned int *copy_count,
 			 unsigned int *state_cnt);
-static int ali_allocate_other_states_resources(struct trident_state *s=
tate,=20
+static int ali_allocate_other_states_resources(struct trident_state *s=
tate,
 					       int chan_nums);
 static void ali_free_other_states_resources(struct trident_state *stat=
e);
=20
@@ -722,7 +722,7 @@ trident_free_pcm_channel(struct trident_
 	if (channel < 31 || channel > 63)
 		return;
=20
-	if (card->pci_id =3D=3D PCI_DEVICE_ID_TRIDENT_4DWAVE_DX ||=20
+	if (card->pci_id =3D=3D PCI_DEVICE_ID_TRIDENT_4DWAVE_DX ||
 	    card->pci_id =3D=3D PCI_DEVICE_ID_TRIDENT_4DWAVE_NX) {
 		b =3D inb(TRID_REG(card, T4D_REC_CH));
 		if ((b & ~0x80) =3D=3D channel)
@@ -742,7 +742,7 @@ cyber_alloc_pcm_channel(struct trident_c
 	int idx;
=20
 	/* The cyberpro 5050 has only 32 voices and one bank */
-	/* .. at least they are not documented (if you want to call that=20
+	/* .. at least they are not documented (if you want to call that
 	 * crap documentation), perhaps broken ? */
=20
 	bank =3D &card->banks[BANK_A];
@@ -802,7 +802,7 @@ cyber_init_ritual(struct trident_card *c
 	/* enable, if it was disabled */
 	if ((portDat & CYBER_BMSK_AUENZ) !=3D CYBER_BMSK_AUENZ_ENABLE) {
 		printk(KERN_INFO "cyberpro5050: enabling audio controller\n");
-		cyber_outidx(CYBER_PORT_AUDIO, CYBER_IDX_AUDIO_ENABLE,=20
+		cyber_outidx(CYBER_PORT_AUDIO, CYBER_IDX_AUDIO_ENABLE,
 			     portDat | CYBER_BMSK_AUENZ_ENABLE);
 		/* check again if hardware is enabled now */
 		portDat =3D cyber_inidx(CYBER_PORT_AUDIO, CYBER_IDX_AUDIO_ENABLE);
@@ -811,7 +811,7 @@ cyber_init_ritual(struct trident_card *c
 		printk(KERN_ERR "cyberpro5050: initAudioAccess: no success\n");
 		ret =3D -1;
 	} else {
-		cyber_outidx(CYBER_PORT_AUDIO, CYBER_IDX_IRQ_ENABLE,=20
+		cyber_outidx(CYBER_PORT_AUDIO, CYBER_IDX_IRQ_ENABLE,
 			     CYBER_BMSK_AUDIO_INT_ENABLE);
 		cyber_outidx(CYBER_PORT_AUDIO, 0xbf, 0x01);
 		cyber_outidx(CYBER_PORT_AUDIO, 0xba, 0x20);
@@ -827,7 +827,7 @@ cyber_init_ritual(struct trident_card *c
 /*  called with spin lock held */
=20
 static int
-trident_load_channel_registers(struct trident_card *card, u32 * data,=20
+trident_load_channel_registers(struct trident_card *card, u32 * data,
 			       unsigned int channel)
 {
 	int i;
@@ -845,7 +845,7 @@ trident_load_channel_registers(struct tr
 			continue;
 		outl(data[i], TRID_REG(card, CHANNEL_START + 4 * i));
 	}
-	if (card->pci_id =3D=3D PCI_DEVICE_ID_ALI_5451 ||=20
+	if (card->pci_id =3D=3D PCI_DEVICE_ID_ALI_5451 ||
 	    card->pci_id =3D=3D PCI_DEVICE_ID_INTERG_5050) {
 		outl(ALI_EMOD_Still, TRID_REG(card, ALI_EBUF1));
 		outl(ALI_EMOD_Still, TRID_REG(card, ALI_EBUF2));
@@ -884,7 +884,7 @@ trident_write_voice_regs(struct trident_
 		break;
 	case PCI_DEVICE_ID_TRIDENT_4DWAVE_NX:
 		data[0] =3D (channel->delta << 24);
-		data[2] =3D ((channel->delta << 16) & 0xff000000) |=20
+		data[2] =3D ((channel->delta << 16) & 0xff000000) |
 			(channel->eso & 0x00ffffff);
 		data[3] =3D channel->fm_vol & 0xffff;
 		break;
@@ -989,13 +989,13 @@ trident_play_setup(struct trident_state=20
 	if (state->card->pci_id !=3D PCI_DEVICE_ID_SI_7018) {
 		channel->attribute =3D 0;
 		if (state->card->pci_id =3D=3D PCI_DEVICE_ID_ALI_5451) {
-			if ((channel->num =3D=3D ALI_SPDIF_IN_CHANNEL) ||=20
+			if ((channel->num =3D=3D ALI_SPDIF_IN_CHANNEL) ||
 			    (channel->num =3D=3D ALI_PCM_IN_CHANNEL))
 				ali_disable_special_channel(state->card, channel->num);
-			else if ((inl(TRID_REG(state->card, ALI_GLOBAL_CONTROL))=20
+			else if ((inl(TRID_REG(state->card, ALI_GLOBAL_CONTROL))
 				  & ALI_SPDIF_OUT_CH_ENABLE)
 				 && (channel->num =3D=3D ALI_SPDIF_OUT_CHANNEL)) {
-				ali_set_spdif_out_rate(state->card,=20
+				ali_set_spdif_out_rate(state->card,
 						       state->dmabuf.rate);
 				state->dmabuf.channel->delta =3D 0x1000;
 			}
@@ -1063,7 +1063,7 @@ trident_rec_setup(struct trident_state *
=20
 	channel->lba =3D dmabuf->dma_handle;
 	channel->delta =3D compute_rate_rec(dmabuf->rate);
-	if ((card->pci_id =3D=3D PCI_DEVICE_ID_ALI_5451) &&=20
+	if ((card->pci_id =3D=3D PCI_DEVICE_ID_ALI_5451) &&
 	    (channel->num =3D=3D ALI_SPDIF_IN_CHANNEL)) {
 		rate =3D ali_get_spdif_in_rate(card);
 		if (rate =3D=3D 0) {
@@ -1180,8 +1180,8 @@ start_adc(struct trident_state *state)
 	unsigned long flags;
=20
 	spin_lock_irqsave(&card->lock, flags);
-	if ((dmabuf->mapped ||=20
-	     dmabuf->count < (signed) dmabuf->dmasize) &&=20
+	if ((dmabuf->mapped ||
+	     dmabuf->count < (signed) dmabuf->dmasize) &&
 	    dmabuf->ready) {
 		dmabuf->enable |=3D ADC_RUNNING;
 		trident_enable_voice_irq(card, chan_num);
@@ -1261,7 +1261,7 @@ alloc_dmabuf(struct dmabuf *dmabuf, stru
 	void *rawbuf =3D NULL;
 	struct page *page, *pend;
=20
-	if (!(rawbuf =3D pci_alloc_consistent(pci_dev, PAGE_SIZE << order,=20
+	if (!(rawbuf =3D pci_alloc_consistent(pci_dev, PAGE_SIZE << order,
 					    &dmabuf->dma_handle)))
 		return -ENOMEM;
=20
@@ -1272,7 +1272,7 @@ alloc_dmabuf(struct dmabuf *dmabuf, stru
 	dmabuf->rawbuf =3D rawbuf;
 	dmabuf->buforder =3D order;
=20
-	/* now mark the pages as reserved; otherwise */=20
+	/* now mark the pages as reserved; otherwise */
 	/* remap_pfn_range doesn't do what we want */
 	pend =3D virt_to_page(rawbuf + (PAGE_SIZE << order) - 1);
 	for (page =3D virt_to_page(rawbuf); page <=3D pend; page++)
@@ -1310,7 +1310,7 @@ dealloc_dmabuf(struct dmabuf *dmabuf, st
 		pend =3D virt_to_page(dmabuf->rawbuf + (PAGE_SIZE << dmabuf->buforde=
r) - 1);
 		for (page =3D virt_to_page(dmabuf->rawbuf); page <=3D pend; page++)
 			ClearPageReserved(page);
-		pci_free_consistent(pci_dev, PAGE_SIZE << dmabuf->buforder,=20
+		pci_free_consistent(pci_dev, PAGE_SIZE << dmabuf->buforder,
 				    dmabuf->rawbuf, dmabuf->dma_handle);
 		dmabuf->rawbuf =3D NULL;
 	}
@@ -1368,7 +1368,7 @@ prog_dmabuf(struct trident_state *state,
 					dealloc_dmabuf(&state->dmabuf, state->card->pci_dev);
 					/* release the auxiliary DMA buffers */
 					for (i -=3D 2; i >=3D 0; i--)
-						dealloc_dmabuf(&state->other_states[i]->dmabuf,=20
+						dealloc_dmabuf(&state->other_states[i]->dmabuf,
 							       state->card->pci_dev);
 					unlock_set_fmt(state);
 					return ret;
@@ -1398,7 +1398,7 @@ prog_dmabuf(struct trident_state *state,
 		dmabuf->fragsamples =3D dmabuf->fragsize >> sample_shift[dmabuf->fmt=
];
 		dmabuf->dmasize =3D dmabuf->numfrag << dmabuf->fragshift;
=20
-		memset(dmabuf->rawbuf, (dmabuf->fmt & TRIDENT_FMT_16BIT) ? 0 : 0x80,=
=20
+		memset(dmabuf->rawbuf, (dmabuf->fmt & TRIDENT_FMT_16BIT) ? 0 : 0x80,
 		       dmabuf->dmasize);
=20
 		spin_lock_irqsave(&s->card->lock, flags);
@@ -1453,7 +1453,7 @@ trident_clear_tail(struct trident_state=20
 	swptr =3D dmabuf->swptr;
 	spin_unlock_irqrestore(&state->card->lock, flags);
=20
-	if (swptr =3D=3D 0 || swptr =3D=3D dmabuf->dmasize / 2 ||=20
+	if (swptr =3D=3D 0 || swptr =3D=3D dmabuf->dmasize / 2 ||
 	    swptr =3D=3D dmabuf->dmasize)
 		return;
=20
@@ -1511,7 +1511,7 @@ drain_dac(struct trident_state *state, i
=20
 		/* No matter how much data is left in the buffer, we have to wait un=
til
 		   CSO =3D=3D ESO/2 or CSO =3D=3D ESO when address engine interrupts=
 */
-		if (state->card->pci_id =3D=3D PCI_DEVICE_ID_ALI_5451 ||=20
+		if (state->card->pci_id =3D=3D PCI_DEVICE_ID_ALI_5451 ||
 		    state->card->pci_id =3D=3D PCI_DEVICE_ID_INTERG_5050) {
 			diff =3D dmabuf->swptr - trident_get_dma_addr(state) + dmabuf->dmas=
ize;
 			diff =3D diff % (dmabuf->dmasize);
@@ -1532,7 +1532,7 @@ drain_dac(struct trident_state *state, i
 	return 0;
 }
=20
-/* update buffer manangement pointers, especially, */=20
+/* update buffer manangement pointers, especially, */
 /* dmabuf->count and dmabuf->hwptr */
 static void
 trident_update_ptr(struct trident_state *state)
@@ -1559,11 +1559,11 @@ trident_update_ptr(struct trident_state=20
 		} else {
 			dmabuf->count +=3D diff;
=20
-			if (dmabuf->count < 0 ||=20
+			if (dmabuf->count < 0 ||
 			    dmabuf->count > dmabuf->dmasize) {
-				/* buffer underrun or buffer overrun, */=20
-				/* we have no way to recover it here, just */=20
-				/* stop the machine and let the process */=20
+				/* buffer underrun or buffer overrun, */
+				/* we have no way to recover it here, just */
+				/* stop the machine and let the process */
 				/* force hwptr and swptr to sync */
 				__stop_adc(state);
 				dmabuf->error++;
@@ -1582,7 +1582,7 @@ trident_update_ptr(struct trident_state=20
 		} else {
 			dmabuf->count -=3D diff;
=20
-			if (dmabuf->count < 0 ||=20
+			if (dmabuf->count < 0 ||
 			    dmabuf->count > dmabuf->dmasize) {
 				/* buffer underrun or buffer overrun, we have no way to recover
 				   it here, just stop the machine and let the process force hwptr
@@ -1608,13 +1608,13 @@ trident_update_ptr(struct trident_state=20
 						if (state->chans_num =3D=3D 6) {
 							clear_cnt =3D clear_cnt / 2;
 							swptr =3D swptr / 2;
-							memset(state->other_states[0]->dmabuf.rawbuf + swptr,=20
+							memset(state->other_states[0]->dmabuf.rawbuf + swptr,
 							       silence, clear_cnt);
-							memset(state->other_states[1]->dmabuf.rawbuf + swptr,=20
+							memset(state->other_states[1]->dmabuf.rawbuf + swptr,
 							       silence, clear_cnt);
-							memset(state->other_states[2]->dmabuf.rawbuf + swptr,=20
+							memset(state->other_states[2]->dmabuf.rawbuf + swptr,
 							       silence, clear_cnt);
-							memset(state->other_states[3]->dmabuf.rawbuf + swptr,=20
+							memset(state->other_states[3]->dmabuf.rawbuf + swptr,
 							       silence, clear_cnt);
 						}
 						dmabuf->endcleared =3D 1;
@@ -1627,13 +1627,13 @@ trident_update_ptr(struct trident_state=20
 					if (state->chans_num =3D=3D 6) {
 						clear_cnt =3D clear_cnt / 2;
 						swptr =3D swptr / 2;
-						memset(state->other_states[0]->dmabuf.rawbuf + swptr,=20
+						memset(state->other_states[0]->dmabuf.rawbuf + swptr,
 						       silence, clear_cnt);
-						memset(state->other_states[1]->dmabuf.rawbuf + swptr,=20
+						memset(state->other_states[1]->dmabuf.rawbuf + swptr,
 						       silence, clear_cnt);
-						memset(state->other_states[2]->dmabuf.rawbuf + swptr,=20
+						memset(state->other_states[2]->dmabuf.rawbuf + swptr,
 						       silence, clear_cnt);
-						memset(state->other_states[3]->dmabuf.rawbuf + swptr,=20
+						memset(state->other_states[3]->dmabuf.rawbuf + swptr,
 						       silence, clear_cnt);
 					}
 					dmabuf->endcleared =3D 1;
@@ -1665,7 +1665,7 @@ trident_address_interrupt(struct trident
 			if ((state =3D card->states[i]) !=3D NULL) {
 				trident_update_ptr(state);
 			} else {
-				printk(KERN_WARNING "trident: spurious channel "=20
+				printk(KERN_WARNING "trident: spurious channel "
 				       "irq %d.\n", channel);
 				trident_stop_voice(card, channel);
 				trident_disable_voice_irq(card, channel);
@@ -1694,7 +1694,7 @@ ali_hwvol_control(struct trident_card *c
=20
 	if (opt =3D=3D 1) {		// MUTE
 		dwTemp ^=3D 0x8000;
-		ali_ac97_write(card->ac97_codec[0],=20
+		ali_ac97_write(card->ac97_codec[0],
 			       0x02, dwTemp);
 	} else if (opt =3D=3D 2) {	// Down
 		if (mute)
@@ -1706,7 +1706,7 @@ ali_hwvol_control(struct trident_card *c
 		dwTemp &=3D 0xe0e0;
 		dwTemp |=3D (volume[0]) | (volume[1] << 8);
 		ali_ac97_write(card->ac97_codec[0], 0x02, dwTemp);
-		card->ac97_codec[0]->mixer_state[0] =3D ((32 - volume[0]) * 25 / 8) =
|=20
+		card->ac97_codec[0]->mixer_state[0] =3D ((32 - volume[0]) * 25 / 8) =
|
 			(((32 - volume[1]) * 25 / 8) << 8);
 	} else if (opt =3D=3D 4) {	// Up
 		if (mute)
@@ -1718,7 +1718,7 @@ ali_hwvol_control(struct trident_card *c
 		dwTemp &=3D 0xe0e0;
 		dwTemp |=3D (volume[0]) | (volume[1] << 8);
 		ali_ac97_write(card->ac97_codec[0], 0x02, dwTemp);
-		card->ac97_codec[0]->mixer_state[0] =3D ((32 - volume[0]) * 25 / 8) =
|=20
+		card->ac97_codec[0]->mixer_state[0] =3D ((32 - volume[0]) * 25 / 8) =
|
 			(((32 - volume[1]) * 25 / 8) << 8);
 	} else {
 		/* Nothing needs doing */
@@ -1801,7 +1801,7 @@ cyber_address_interrupt(struct trident_c
 			if ((state =3D card->states[i]) !=3D NULL) {
 				trident_update_ptr(state);
 			} else {
-				printk(KERN_WARNING "cyber5050: spurious "=20
+				printk(KERN_WARNING "cyber5050: spurious "
 				       "channel irq %d.\n", channel);
 				trident_stop_voice(card, channel);
 				trident_disable_voice_irq(card, channel);
@@ -1836,21 +1836,21 @@ trident_interrupt(int irq, void *dev_id)
 				ali_queue_task(card, gpio & 0x07);
 		}
 		event =3D inl(TRID_REG(card, T4D_MISCINT));
-		outl(event | (ST_TARGET_REACHED | MIXER_OVERFLOW | MIXER_UNDERFLOW),=
=20
+		outl(event | (ST_TARGET_REACHED | MIXER_OVERFLOW | MIXER_UNDERFLOW),
 		     TRID_REG(card, T4D_MISCINT));
 		spin_unlock(&card->lock);
 		return IRQ_HANDLED;
 	}
=20
 	/* manually clear interrupt status, bad hardware design, blame T^2 */
-	outl((ST_TARGET_REACHED | MIXER_OVERFLOW | MIXER_UNDERFLOW),=20
+	outl((ST_TARGET_REACHED | MIXER_OVERFLOW | MIXER_UNDERFLOW),
 	     TRID_REG(card, T4D_MISCINT));
 	spin_unlock(&card->lock);
 	return IRQ_HANDLED;
 }
=20
-/* in this loop, dmabuf.count signifies the amount of data that is wai=
ting */=20
-/* to be copied to the user's buffer.  it is filled by the dma machine=
 and */=20
+/* in this loop, dmabuf.count signifies the amount of data that is wai=
ting */
+/* to be copied to the user's buffer.  it is filled by the dma machine=
 and */
 /* drained by this loop. */
 static ssize_t
 trident_read(struct file *file, char __user *buffer, size_t count, lof=
f_t * ppos)
@@ -1878,8 +1878,8 @@ trident_read(struct file *file, char __u
 	while (count > 0) {
 		spin_lock_irqsave(&state->card->lock, flags);
 		if (dmabuf->count > (signed) dmabuf->dmasize) {
-			/* buffer overrun, we are recovering from */=20
-			/* sleep_on_timeout, resync hwptr and swptr, */=20
+			/* buffer overrun, we are recovering from */
+			/* sleep_on_timeout, resync hwptr and swptr, */
 			/* make process flush the buffer */
 			dmabuf->count =3D dmabuf->dmasize;
 			dmabuf->swptr =3D dmabuf->hwptr;
@@ -1894,7 +1894,7 @@ trident_read(struct file *file, char __u
 			cnt =3D count;
 		if (cnt <=3D 0) {
 			unsigned long tmo;
-			/* buffer is empty, start the dma machine and */=20
+			/* buffer is empty, start the dma machine and */
 			/* wait for data to be recorded */
 			start_adc(state);
 			if (file->f_flags & O_NONBLOCK) {
@@ -1904,8 +1904,8 @@ trident_read(struct file *file, char __u
 			}
=20
 			mutex_unlock(&state->sem);
-			/* No matter how much space left in the buffer, */=20
-			/* we have to wait until CSO =3D=3D ESO/2 or CSO =3D=3D ESO */=20
+			/* No matter how much space left in the buffer, */
+			/* we have to wait until CSO =3D=3D ESO/2 or CSO =3D=3D ESO */
 			/* when address engine interrupts */
 			tmo =3D (dmabuf->dmasize * HZ) / (dmabuf->rate * 2);
 			tmo >>=3D sample_shift[dmabuf->fmt];
@@ -2005,7 +2005,7 @@ trident_write(struct file *file, const c
 	while (count > 0) {
 		spin_lock_irqsave(&state->card->lock, flags);
 		if (dmabuf->count < 0) {
-			/* buffer underrun, we are recovering from */=20
+			/* buffer underrun, we are recovering from */
 			/* sleep_on_timeout, resync hwptr and swptr */
 			dmabuf->count =3D 0;
 			dmabuf->swptr =3D dmabuf->hwptr;
@@ -2020,7 +2020,7 @@ trident_write(struct file *file, const c
 			cnt =3D count;
 		if (cnt <=3D 0) {
 			unsigned long tmo;
-			/* buffer is full, start the dma machine and */=20
+			/* buffer is full, start the dma machine and */
 			/* wait for data to be played */
 			start_dac(state);
 			if (file->f_flags & O_NONBLOCK) {
@@ -2028,8 +2028,8 @@ trident_write(struct file *file, const c
 					ret =3D -EAGAIN;
 				goto out;
 			}
-			/* No matter how much data left in the buffer, */=20
-			/* we have to wait until CSO =3D=3D ESO/2 or CSO =3D=3D ESO */=20
+			/* No matter how much data left in the buffer, */
+			/* we have to wait until CSO =3D=3D ESO/2 or CSO =3D=3D ESO */
 			/* when address engine interrupts */
 			lock_set_fmt(state);
 			tmo =3D (dmabuf->dmasize * HZ) / (dmabuf->rate * 2);
@@ -2037,15 +2037,15 @@ trident_write(struct file *file, const c
 			unlock_set_fmt(state);
 			mutex_unlock(&state->sem);
=20
-			/* There are two situations when sleep_on_timeout */=20
-			/* returns, one is when the interrupt is serviced */=20
-			/* correctly and the process is waked up by ISR */=20
-			/* ON TIME. Another is when timeout is expired, which */=20
-			/* means that either interrupt is NOT serviced */=20
-			/* correctly (pending interrupt) or it is TOO LATE */=20
-			/* for the process to be scheduled to run */=20
-			/* (scheduler latency) which results in a (potential) */=20
-			/* buffer underrun. And worse, there is NOTHING we */=20
+			/* There are two situations when sleep_on_timeout */
+			/* returns, one is when the interrupt is serviced */
+			/* correctly and the process is waked up by ISR */
+			/* ON TIME. Another is when timeout is expired, which */
+			/* means that either interrupt is NOT serviced */
+			/* correctly (pending interrupt) or it is TOO LATE */
+			/* for the process to be scheduled to run */
+			/* (scheduler latency) which results in a (potential) */
+			/* buffer underrun. And worse, there is NOTHING we */
 			/* can do to prevent it. */
 			if (!interruptible_sleep_on_timeout(&dmabuf->wait, tmo)) {
 				pr_debug(KERN_ERR "trident: playback schedule "
@@ -2054,8 +2054,8 @@ trident_write(struct file *file, const c
 					 dmabuf->fragsize, dmabuf->count,
 					 dmabuf->hwptr, dmabuf->swptr);
=20
-				/* a buffer underrun, we delay the recovery */=20
-				/* until next time the while loop begin and */=20
+				/* a buffer underrun, we delay the recovery */
+				/* until next time the while loop begin and */
 				/* we REALLY have data to play */
 			}
 			if (signal_pending(current)) {
@@ -2079,7 +2079,7 @@ trident_write(struct file *file, const c
 		if (state->chans_num =3D=3D 6) {
 			copy_count =3D 0;
 			state_cnt =3D 0;
-			if (ali_write_5_1(state, buffer, cnt, &copy_count,=20
+			if (ali_write_5_1(state, buffer, cnt, &copy_count,
 					  &state_cnt) =3D=3D -EFAULT) {
 				if (state_cnt) {
 					swptr =3D (swptr + state_cnt) % dmabuf->dmasize;
@@ -2096,7 +2096,7 @@ trident_write(struct file *file, const c
 				goto out;
 			}
 		} else {
-			if (copy_from_user(dmabuf->rawbuf + swptr,=20
+			if (copy_from_user(dmabuf->rawbuf + swptr,
 					   buffer, cnt)) {
 				if (!ret)
 					ret =3D -EFAULT;
@@ -2172,7 +2172,7 @@ trident_poll(struct file *file, struct p
 			if (dmabuf->count >=3D (signed) dmabuf->fragsize)
 				mask |=3D POLLOUT | POLLWRNORM;
 		} else {
-			if ((signed) dmabuf->dmasize >=3D dmabuf->count +=20
+			if ((signed) dmabuf->dmasize >=3D dmabuf->count +
 			    (signed) dmabuf->fragsize)
 				mask |=3D POLLOUT | POLLWRNORM;
 		}
@@ -2227,7 +2227,7 @@ out:
 }
=20
 static int
-trident_ioctl(struct inode *inode, struct file *file,=20
+trident_ioctl(struct inode *inode, struct file *file,
 	      unsigned int cmd, unsigned long arg)
 {
 	struct trident_state *state =3D (struct trident_state *)file->private=
_data;
@@ -2348,7 +2348,7 @@ trident_ioctl(struct inode *inode, struc
=20
=20
 	case SNDCTL_DSP_GETFMTS: /* Returns a mask of supported sample format=
 */
-		ret =3D put_user(AFMT_S16_LE | AFMT_U16_LE | AFMT_S8 |=20
+		ret =3D put_user(AFMT_S16_LE | AFMT_U16_LE | AFMT_S8 |
 			       AFMT_U8, p);
 		break;
=20
@@ -2379,7 +2379,7 @@ trident_ioctl(struct inode *inode, struc
 			}
 		}
 		unlock_set_fmt(state);
-		ret =3D put_user((dmabuf->fmt & TRIDENT_FMT_16BIT) ? AFMT_S16_LE :=20
+		ret =3D put_user((dmabuf->fmt & TRIDENT_FMT_16BIT) ? AFMT_S16_LE :
 			       AFMT_U8, p);
 		break;
=20
@@ -2438,7 +2438,7 @@ trident_ioctl(struct inode *inode, struc
 				stop_adc(state);
 				dmabuf->ready =3D 0;
 				if (val >=3D 2) {
-					if (!((file->f_mode & FMODE_WRITE) &&=20
+					if (!((file->f_mode & FMODE_WRITE) &&
 					      (val =3D=3D 6)))
 						val =3D 2;
 					dmabuf->fmt |=3D TRIDENT_FMT_STEREO;
@@ -2504,7 +2504,7 @@ trident_ioctl(struct inode *inode, struc
 		abinfo.fragstotal =3D dmabuf->numfrag;
 		abinfo.fragments =3D abinfo.bytes >> dmabuf->fragshift;
 		spin_unlock_irqrestore(&state->card->lock, flags);
-		ret =3D copy_to_user(argp, &abinfo, sizeof (abinfo)) ?=20
+		ret =3D copy_to_user(argp, &abinfo, sizeof (abinfo)) ?
 			-EFAULT : 0;
 		break;
=20
@@ -2524,7 +2524,7 @@ trident_ioctl(struct inode *inode, struc
 		abinfo.fragstotal =3D dmabuf->numfrag;
 		abinfo.fragments =3D abinfo.bytes >> dmabuf->fragshift;
 		spin_unlock_irqrestore(&state->card->lock, flags);
-		ret =3D copy_to_user(argp, &abinfo, sizeof (abinfo)) ?=20
+		ret =3D copy_to_user(argp, &abinfo, sizeof (abinfo)) ?
 			-EFAULT : 0;
 		break;
=20
@@ -2533,7 +2533,7 @@ trident_ioctl(struct inode *inode, struc
 		break;
=20
 	case SNDCTL_DSP_GETCAPS:
-		ret =3D put_user(DSP_CAP_REALTIME | DSP_CAP_TRIGGER |=20
+		ret =3D put_user(DSP_CAP_REALTIME | DSP_CAP_TRIGGER |
 			       DSP_CAP_MMAP | DSP_CAP_BIND, p);
 		break;
=20
@@ -2553,7 +2553,7 @@ trident_ioctl(struct inode *inode, struc
 		}
 		if (file->f_mode & FMODE_READ) {
 			if (val & PCM_ENABLE_INPUT) {
-				if (!dmabuf->ready &&=20
+				if (!dmabuf->ready &&
 				    (ret =3D prog_dmabuf_record(state)))
 					break;
 				start_adc(state);
@@ -2562,7 +2562,7 @@ trident_ioctl(struct inode *inode, struc
 		}
 		if (file->f_mode & FMODE_WRITE) {
 			if (val & PCM_ENABLE_OUTPUT) {
-				if (!dmabuf->ready &&=20
+				if (!dmabuf->ready &&
 				    (ret =3D prog_dmabuf_playback(state)))
 					break;
 				start_dac(state);
@@ -2589,7 +2589,7 @@ trident_ioctl(struct inode *inode, struc
 		if (dmabuf->mapped)
 			dmabuf->count &=3D dmabuf->fragsize - 1;
 		spin_unlock_irqrestore(&state->card->lock, flags);
-		ret =3D copy_to_user(argp, &cinfo, sizeof (cinfo)) ?=20
+		ret =3D copy_to_user(argp, &cinfo, sizeof (cinfo)) ?
 			-EFAULT : 0;
 		break;
=20
@@ -2612,7 +2612,7 @@ trident_ioctl(struct inode *inode, struc
 		if (dmabuf->mapped)
 			dmabuf->count &=3D dmabuf->fragsize - 1;
 		spin_unlock_irqrestore(&state->card->lock, flags);
-		ret =3D copy_to_user(argp, &cinfo, sizeof (cinfo)) ?=20
+		ret =3D copy_to_user(argp, &cinfo, sizeof (cinfo)) ?
 			-EFAULT : 0;
 		break;
=20
@@ -2641,17 +2641,17 @@ trident_ioctl(struct inode *inode, struc
 		break;
=20
 	case SOUND_PCM_READ_CHANNELS:
-		ret =3D put_user((dmabuf->fmt & TRIDENT_FMT_STEREO) ? 2 : 1,=20
+		ret =3D put_user((dmabuf->fmt & TRIDENT_FMT_STEREO) ? 2 : 1,
 			       p);
 		break;
=20
 	case SOUND_PCM_READ_BITS:
-		ret =3D put_user((dmabuf->fmt & TRIDENT_FMT_16BIT) ? AFMT_S16_LE :=20
+		ret =3D put_user((dmabuf->fmt & TRIDENT_FMT_16BIT) ? AFMT_S16_LE :
 			       AFMT_U8, p);
 		break;
=20
 	case SNDCTL_DSP_GETCHANNELMASK:
-		ret =3D put_user(DSP_BIND_FRONT | DSP_BIND_SURR |=20
+		ret =3D put_user(DSP_BIND_FRONT | DSP_BIND_SURR |
 			       DSP_BIND_CENTER_LFE,  p);
 		break;
=20
@@ -2671,10 +2671,10 @@ trident_ioctl(struct inode *inode, struc
 		} else {
 			dmabuf->ready =3D 0;
 			if (file->f_mode & FMODE_READ)
-				dmabuf->channel->attribute =3D (CHANNEL_REC |=20
+				dmabuf->channel->attribute =3D (CHANNEL_REC |
 							      SRC_ENABLE);
 			if (file->f_mode & FMODE_WRITE)
-				dmabuf->channel->attribute =3D (CHANNEL_SPC_PB |=20
+				dmabuf->channel->attribute =3D (CHANNEL_SPC_PB |
 							      SRC_ENABLE);
 			dmabuf->channel->attribute |=3D mask2attr[ffs(val)];
 		}
@@ -2765,8 +2765,8 @@ trident_open(struct inode *inode, struct
 	init_waitqueue_head(&dmabuf->wait);
 	file->private_data =3D state;
=20
-	/* set default sample format. According to OSS Programmer's */=20
-	/* Guide  /dev/dsp should be default to unsigned 8-bits, mono, */=20
+	/* set default sample format. According to OSS Programmer's */
+	/* Guide  /dev/dsp should be default to unsigned 8-bits, mono, */
 	/* with sample rate 8kHz and /dev/dspW will accept 16-bits sample */
 	if (file->f_mode & FMODE_WRITE) {
 		dmabuf->fmt &=3D ~TRIDENT_FMT_MASK;
@@ -2783,7 +2783,7 @@ trident_open(struct inode *inode, struct
 	}
=20
 	if (file->f_mode & FMODE_READ) {
-		/* FIXME: Trident 4d can only record in signed 16-bits stereo, */=20
+		/* FIXME: Trident 4d can only record in signed 16-bits stereo, */
 		/* 48kHz sample, to be dealed with in trident_set_adc_rate() ?? */
 		dmabuf->fmt &=3D ~TRIDENT_FMT_MASK;
 		if ((minor & 0x0f) =3D=3D SND_DEV_DSP16)
@@ -2794,7 +2794,7 @@ trident_open(struct inode *inode, struct
 		if (card->pci_id =3D=3D PCI_DEVICE_ID_SI_7018) {
 			/* set default channel attribute to 0x8a80, record from
 			   PCM L/R FIFO and mono =3D (left + right + 1)/2 */
-			dmabuf->channel->attribute =3D (CHANNEL_REC | PCM_LR |=20
+			dmabuf->channel->attribute =3D (CHANNEL_REC | PCM_LR |
 						      MONO_MIX);
 		}
 		trident_set_adc_rate(state, 8000);
@@ -3020,7 +3020,7 @@ acquirecodecaccess(struct trident_card *
 			break;
 		if (wsemabits =3D=3D 0) {
 		      unlock:
-			outl(((u32) (wcontrol & 0x1eff) | 0x00004000),=20
+			outl(((u32) (wcontrol & 0x1eff) | 0x00004000),
 			     TRID_REG(card, ALI_AC97_WRITE));
 			continue;
 		}
@@ -3104,7 +3104,7 @@ ali_ac97_get(struct trident_card *card,=20
 	ncount =3D 10;
=20
 	while (1) {
-		if ((inw(TRID_REG(card, ALI_AC97_WRITE)) & ALI_AC97_BUSY_READ)=20
+		if ((inw(TRID_REG(card, ALI_AC97_WRITE)) & ALI_AC97_BUSY_READ)
 		    !=3D 0)
 			break;
 		if (ncount <=3D 0)
@@ -3112,7 +3112,7 @@ ali_ac97_get(struct trident_card *card,=20
 		if (ncount-- =3D=3D 1) {
 			pr_debug("ali_ac97_read :try clear busy flag\n");
 			aud_reg =3D inl(TRID_REG(card, ALI_AC97_WRITE));
-			outl((aud_reg & 0xffff7fff),=20
+			outl((aud_reg & 0xffff7fff),
 			     TRID_REG(card, ALI_AC97_WRITE));
 		}
 		udelay(10);
@@ -3159,7 +3159,7 @@ ali_ac97_set(struct trident_card *card,=20
=20
 	wcontrol =3D inw(TRID_REG(card, ALI_AC97_WRITE));
 	wcontrol &=3D 0xff00;
-	wcontrol |=3D (0x8100 | reg); /* bit 8=3D1: (ali1535 )reserved/ */=20
+	wcontrol |=3D (0x8100 | reg); /* bit 8=3D1: (ali1535 )reserved/ */
 	                            /* ali1535+ write */
 	outl((data | wcontrol), TRID_REG(card, ALI_AC97_WRITE));
=20
@@ -3177,7 +3177,7 @@ ali_ac97_set(struct trident_card *card,=20
 			break;
 		if (ncount-- =3D=3D 1) {
 			pr_debug("ali_ac97_set :try clear busy flag!!\n");
-			outw(wcontrol & 0x7fff,=20
+			outw(wcontrol & 0x7fff,
 			     TRID_REG(card, ALI_AC97_WRITE));
 		}
 		udelay(10);
@@ -3382,7 +3382,7 @@ ali_detect_spdif_rate(struct trident_car
 	bval |=3D 0x1F;
 	outb(bval, TRID_REG(card, ALI_SPDIF_CTRL + 1));
=20
-	while (((R1 < 0x0B) || (R1 > 0x0E)) && (R1 !=3D 0x12) &&=20
+	while (((R1 < 0x0B) || (R1 > 0x0E)) && (R1 !=3D 0x12) &&
 	       count <=3D 50000) {
 		count++;
=20
@@ -3669,14 +3669,14 @@ ali_save_regs(struct trident_card *card)
 	spin_lock_irqsave(&card->lock, flags);
=20
 	ali_registers.global_regs[0x2c] =3D inl(TRID_REG(card, T4D_MISCINT));
-	//ali_registers.global_regs[0x20] =3D inl(TRID_REG(card,T4D_START_A))=
;   =20
+	//ali_registers.global_regs[0x20] =3D inl(TRID_REG(card,T4D_START_A))=
;
 	ali_registers.global_regs[0x21] =3D inl(TRID_REG(card, T4D_STOP_A));
=20
 	//disable all IRQ bits
 	outl(ALI_DISABLE_ALL_IRQ, TRID_REG(card, T4D_MISCINT));
=20
 	for (i =3D 1; i < ALI_MIXER_REGS; i++)
-		ali_registers.mixer_regs[i] =3D ali_ac97_read(card->ac97_codec[0],=20
+		ali_registers.mixer_regs[i] =3D ali_ac97_read(card->ac97_codec[0],
 							    i * 2);
=20
 	for (i =3D 0; i < ALI_GLOBAL_REGS; i++) {
@@ -3688,7 +3688,7 @@ ali_save_regs(struct trident_card *card)
 	for (i =3D 0; i < ALI_CHANNELS; i++) {
 		outb(i, TRID_REG(card, T4D_LFO_GC_CIR));
 		for (j =3D 0; j < ALI_CHANNEL_REGS; j++)
-			ali_registers.channel_regs[i][j] =3D inl(TRID_REG(card,=20
+			ali_registers.channel_regs[i][j] =3D inl(TRID_REG(card,
 									j * 4 + 0xe0));
 	}
=20
@@ -3707,18 +3707,18 @@ ali_restore_regs(struct trident_card *ca
 	spin_lock_irqsave(&card->lock, flags);
=20
 	for (i =3D 1; i < ALI_MIXER_REGS; i++)
-		ali_ac97_write(card->ac97_codec[0], i * 2,=20
+		ali_ac97_write(card->ac97_codec[0], i * 2,
 			       ali_registers.mixer_regs[i]);
=20
 	for (i =3D 0; i < ALI_CHANNELS; i++) {
 		outb(i, TRID_REG(card, T4D_LFO_GC_CIR));
 		for (j =3D 0; j < ALI_CHANNEL_REGS; j++)
-			outl(ali_registers.channel_regs[i][j],=20
+			outl(ali_registers.channel_regs[i][j],
 			     TRID_REG(card, j * 4 + 0xe0));
 	}
=20
 	for (i =3D 0; i < ALI_GLOBAL_REGS; i++) {
-		if ((i * 4 =3D=3D T4D_MISCINT) || (i * 4 =3D=3D T4D_STOP_A) ||=20
+		if ((i * 4 =3D=3D T4D_MISCINT) || (i * 4 =3D=3D T4D_STOP_A) ||
 		    (i * 4 =3D=3D T4D_START_A))
 			continue;
 		outl(ali_registers.global_regs[i], TRID_REG(card, i * 4));
@@ -3763,7 +3763,7 @@ ali_alloc_pcm_channel(struct trident_car
=20
 	bank =3D &card->banks[BANK_A];
=20
-	if (inl(TRID_REG(card, ALI_GLOBAL_CONTROL)) &=20
+	if (inl(TRID_REG(card, ALI_GLOBAL_CONTROL)) &
 	    (ALI_SPDIF_OUT_CH_ENABLE)) {
 		idx =3D ALI_SPDIF_OUT_CHANNEL;
 		if (!(bank->bitmap & (1 << idx))) {
@@ -3774,7 +3774,7 @@ ali_alloc_pcm_channel(struct trident_car
 		}
 	}
=20
-	for (idx =3D ALI_PCM_OUT_CHANNEL_FIRST; idx <=3D ALI_PCM_OUT_CHANNEL_=
LAST;=20
+	for (idx =3D ALI_PCM_OUT_CHANNEL_FIRST; idx <=3D ALI_PCM_OUT_CHANNEL_=
LAST;
 	     idx++) {
 		if (!(bank->bitmap & (1 << idx))) {
 			struct trident_channel *channel =3D &bank->channels[idx];
@@ -3785,9 +3785,9 @@ ali_alloc_pcm_channel(struct trident_car
 	}
=20
 	/* no more free channels avaliable */
-#if 0=20
+#if 0
 	printk(KERN_ERR "ali: no more channels available on Bank A.\n");
-#endif /* 0 */=20
+#endif /* 0 */
 	return NULL;
 }
=20
@@ -3812,9 +3812,9 @@ ali_alloc_rec_pcm_channel(struct trident
 	}
=20
 	/* no free recordable channels avaliable */
-#if 0=20
+#if 0
 	printk(KERN_ERR "ali: no recordable channels available on Bank A.\n")=
;
-#endif /* 0 */=20
+#endif /* 0 */
 	return NULL;
 }
=20
@@ -3837,14 +3837,14 @@ ali_set_spdif_out_rate(struct trident_ca
 		break;
 	}
=20
-	/* select spdif_out */=20
+	/* select spdif_out */
 	ch_st_sel =3D inb(TRID_REG(card, ALI_SPDIF_CTRL)) & ALI_SPDIF_OUT_CH_=
STATUS;
=20
-	ch_st_sel |=3D 0x80;	/* select right */=20
+	ch_st_sel |=3D 0x80;	/* select right */
 	outb(ch_st_sel, TRID_REG(card, ALI_SPDIF_CTRL));
 	outb(status_rate | 0x20, TRID_REG(card, ALI_SPDIF_CS + 2));
=20
-	ch_st_sel &=3D (~0x80);	/* select left */=20
+	ch_st_sel &=3D (~0x80);	/* select left */
 	outb(ch_st_sel, TRID_REG(card, ALI_SPDIF_CTRL));
 	outw(status_rate | 0x10, TRID_REG(card, ALI_SPDIF_CS + 2));
 }
@@ -3881,14 +3881,14 @@ ali_address_interrupt(struct trident_car
 	}
 }
=20
-/* Updating the values of counters of other_states' DMAs without lock=20
+/* Updating the values of counters of other_states' DMAs without lock
 protection is no harm because all DMAs of multi-channels and interrupt
 depend on a master state's DMA, and changing the counters of the maste=
r
 state DMA is protected by a spinlock.
 */
 static int
-ali_write_5_1(struct trident_state *state, const char __user *buf,=20
-	      int cnt_for_multi_channel, unsigned int *copy_count,=20
+ali_write_5_1(struct trident_state *state, const char __user *buf,
+	      int cnt_for_multi_channel, unsigned int *copy_count,
 	      unsigned int *state_cnt)
 {
=20
@@ -3904,10 +3904,10 @@ ali_write_5_1(struct trident_state *stat
=20
 	if ((i =3D state->multi_channels_adjust_count) > 0) {
 		if (i =3D=3D 1) {
-			if (copy_from_user(dmabuf->rawbuf + swptr,=20
+			if (copy_from_user(dmabuf->rawbuf + swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(swptr, buffer, cnt_for_multi_channel,=20
+			seek_offset(swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 			i--;
 			(*state_cnt) +=3D sample_s;
@@ -3916,10 +3916,10 @@ ali_write_5_1(struct trident_state *stat
 			i =3D i - (state->chans_num - other_dma_nums);
 		for (; (i < other_dma_nums) && (cnt_for_multi_channel > 0); i++) {
 			dmabuf_temp =3D &state->other_states[i]->dmabuf;
-			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,=20
+			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,=20
+			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 		}
 		if (cnt_for_multi_channel =3D=3D 0)
@@ -3928,39 +3928,39 @@ ali_write_5_1(struct trident_state *stat
 	if (cnt_for_multi_channel > 0) {
 		loop =3D cnt_for_multi_channel / (state->chans_num * sample_s);
 		for (i =3D 0; i < loop; i++) {
-			if (copy_from_user(dmabuf->rawbuf + swptr, buffer,=20
+			if (copy_from_user(dmabuf->rawbuf + swptr, buffer,
 					   sample_s * 2))
 				return -EFAULT;
-			seek_offset(swptr, buffer, cnt_for_multi_channel,=20
+			seek_offset(swptr, buffer, cnt_for_multi_channel,
 				    sample_s * 2, *copy_count);
 			(*state_cnt) +=3D (sample_s * 2);
=20
 			dmabuf_temp =3D &state->other_states[0]->dmabuf;
-			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,=20
+			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,=20
+			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
=20
 			dmabuf_temp =3D &state->other_states[1]->dmabuf;
-			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,=20
+			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,=20
+			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
=20
 			dmabuf_temp =3D &state->other_states[2]->dmabuf;
-			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,=20
+			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,=20
+			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
=20
 			dmabuf_temp =3D &state->other_states[3]->dmabuf;
-			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,=20
+			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,=20
+			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 		}
=20
@@ -3969,15 +3969,15 @@ ali_write_5_1(struct trident_state *stat
=20
 			if (copy_from_user(dmabuf->rawbuf + swptr, buffer, sample_s))
 				return -EFAULT;
-			seek_offset(swptr, buffer, cnt_for_multi_channel,=20
+			seek_offset(swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 			(*state_cnt) +=3D sample_s;
=20
 			if (cnt_for_multi_channel > 0) {
-				if (copy_from_user(dmabuf->rawbuf + swptr,=20
+				if (copy_from_user(dmabuf->rawbuf + swptr,
 						   buffer, sample_s))
 					return -EFAULT;
-				seek_offset(swptr, buffer, cnt_for_multi_channel,=20
+				seek_offset(swptr, buffer, cnt_for_multi_channel,
 					    sample_s, *copy_count);
 				(*state_cnt) +=3D sample_s;
=20
@@ -3986,12 +3986,12 @@ ali_write_5_1(struct trident_state *stat
 					loop =3D state->multi_channels_adjust_count - diff;
 					for (i =3D 0; i < loop; i++) {
 						dmabuf_temp =3D &state->other_states[i]->dmabuf;
-						if (copy_from_user(dmabuf_temp->rawbuf +=20
-								   dmabuf_temp->swptr,=20
+						if (copy_from_user(dmabuf_temp->rawbuf +
+								   dmabuf_temp->swptr,
 								   buffer, sample_s))
 							return -EFAULT;
-						seek_offset(dmabuf_temp->swptr, buffer,=20
-							    cnt_for_multi_channel,=20
+						seek_offset(dmabuf_temp->swptr, buffer,
+							    cnt_for_multi_channel,
 							    sample_s, *copy_count);
 					}
 				}
@@ -4048,11 +4048,11 @@ ali_write_proc(struct file *file, const=20
 		ali_disable_special_channel(card, ALI_SPDIF_OUT_CHANNEL);
 		break;
 	case '1':
-		ali_setup_spdif_out(card, ALI_SPDIF_OUT_TO_SPDIF_OUT |=20
+		ali_setup_spdif_out(card, ALI_SPDIF_OUT_TO_SPDIF_OUT |
 				    ALI_SPDIF_OUT_PCM);
 		break;
 	case '2':
-		ali_setup_spdif_out(card, ALI_SPDIF_OUT_TO_SPDIF_OUT |=20
+		ali_setup_spdif_out(card, ALI_SPDIF_OUT_TO_SPDIF_OUT |
 				    ALI_SPDIF_OUT_NON_PCM);
 		break;
 	case '3':
@@ -4077,7 +4077,7 @@ trident_open_mixdev(struct inode *inode,
=20
 	for (card =3D devs; card !=3D NULL; card =3D card->next)
 		for (i =3D 0; i < NR_AC97; i++)
-			if (card->ac97_codec[i] !=3D NULL &&=20
+			if (card->ac97_codec[i] !=3D NULL &&
 			    card->ac97_codec[i]->dev_mixer =3D=3D minor)
 				goto match;
=20
@@ -4091,7 +4091,7 @@ trident_open_mixdev(struct inode *inode,
 }
=20
 static int
-trident_ioctl_mixdev(struct inode *inode, struct file *file, unsigned =
int cmd,=20
+trident_ioctl_mixdev(struct inode *inode, struct file *file, unsigned =
int cmd,
 		     unsigned long arg)
 {
 	struct ac97_codec *codec =3D (struct ac97_codec *) file->private_data=
;
@@ -4185,9 +4185,9 @@ trident_ac97_init(struct trident_card *c
 		/* disable AC97 GPIO interrupt */
 		outl(0x00, TRID_REG(card, SI_AC97_GPIO));
 		/* when power up the AC link is in cold reset mode so stop it */
-		outl(PCMOUT | SURROUT | CENTEROUT | LFEOUT | SECONDARY_ID,=20
+		outl(PCMOUT | SURROUT | CENTEROUT | LFEOUT | SECONDARY_ID,
 		     TRID_REG(card, SI_SERIAL_INTF_CTRL));
-		/* it take a long time to recover from a cold reset */=20
+		/* it take a long time to recover from a cold reset */
 		/* (especially when you have more than one codec) */
 		udelay(2000);
 		ready_2nd =3D inl(TRID_REG(card, SI_SERIAL_INTF_CTRL));
@@ -4207,9 +4207,9 @@ trident_ac97_init(struct trident_card *c
 		/* disable AC97 GPIO interrupt */
 		outl(0x00, TRID_REG(card, SI_AC97_GPIO));
 		/* when power up, the AC link is in cold reset mode, so stop it */
-		outl(PCMOUT | SURROUT | CENTEROUT | LFEOUT,=20
+		outl(PCMOUT | SURROUT | CENTEROUT | LFEOUT,
 		     TRID_REG(card, SI_SERIAL_INTF_CTRL));
-		/* it take a long time to recover from a cold reset (especially */=20
+		/* it take a long time to recover from a cold reset (especially */
 		/* when you have more than one codec) */
 		udelay(2000);
 		ready_2nd =3D inl(TRID_REG(card, SI_SERIAL_INTF_CTRL));
@@ -4221,7 +4221,7 @@ trident_ac97_init(struct trident_card *c
 		if ((codec =3D ac97_alloc_codec()) =3D=3D NULL)
 			return -ENOMEM;
=20
-		/* initialize some basic codec information, other fields */=20
+		/* initialize some basic codec information, other fields */
 		/* will be filled in ac97_probe_codec */
 		codec->private_data =3D card;
 		codec->id =3D num_ac97;
@@ -4352,8 +4352,8 @@ static inline int trident_register_gamep
 static inline void trident_unregister_gameport(struct trident_card *ca=
rd) { }
 #endif /* SUPPORT_JOYSTICK */
=20
-/* install the driver, we do not allocate hardware channel nor DMA buf=
fer */=20
-/* now, they are defered until "ACCESS" time (in prog_dmabuf called by=
 */=20
+/* install the driver, we do not allocate hardware channel nor DMA buf=
fer */
+/* now, they are defered until "ACCESS" time (in prog_dmabuf called by=
 */
 /* open/read/write/ioctl/mmap) */
 static int __devinit
 trident_probe(struct pci_dev *pci_dev, const struct pci_device_id *pci=
_id)
@@ -4376,9 +4376,9 @@ trident_probe(struct pci_dev *pci_dev, c
 	else
 		dma_mask =3D TRIDENT_DMA_MASK;
 	if (pci_set_dma_mask(pci_dev, dma_mask)) {
-		printk(KERN_ERR "trident: architecture does not support"=20
-		       " %s PCI busmaster DMA\n",=20
-		       pci_dev->device =3D=3D PCI_DEVICE_ID_ALI_5451 ?=20
+		printk(KERN_ERR "trident: architecture does not support"
+		       " %s PCI busmaster DMA\n",
+		       pci_dev->device =3D=3D PCI_DEVICE_ID_ALI_5451 ?
 		       "32-bit" : "30-bit");
 		goto out;
 	}
@@ -4422,7 +4422,7 @@ trident_probe(struct pci_dev *pci_dev, c
=20
 	pci_set_master(pci_dev);
=20
-	printk(KERN_INFO "trident: %s found at IO 0x%04lx, IRQ %d\n",=20
+	printk(KERN_INFO "trident: %s found at IO 0x%04lx, IRQ %d\n",
 	       card_names[pci_id->driver_data], card->iobase, card->irq);
=20
 	if (card->pci_id =3D=3D PCI_DEVICE_ID_ALI_5451) {
@@ -4449,8 +4449,8 @@ trident_probe(struct pci_dev *pci_dev, c
=20
 		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */
 		card->hwvolctl =3D 0;
-		pci_dev_m1533 =3D pci_find_device(PCI_VENDOR_ID_AL,=20
-						PCI_DEVICE_ID_AL_M1533,=20
+		pci_dev_m1533 =3D pci_find_device(PCI_VENDOR_ID_AL,
+						PCI_DEVICE_ID_AL_M1533,
 						pci_dev_m1533);
 		rc =3D -ENODEV;
 		if (pci_dev_m1533 =3D=3D NULL)
@@ -4482,7 +4482,7 @@ trident_probe(struct pci_dev *pci_dev, c
 	rc =3D -ENODEV;
 	if (request_irq(card->irq, &trident_interrupt, IRQF_SHARED,
 			card_names[pci_id->driver_data], card)) {
-		printk(KERN_ERR "trident: unable to allocate irq %d\n",=20
+		printk(KERN_ERR "trident: unable to allocate irq %d\n",
 		       card->irq);
 		goto out_proc_fs;
 	}
@@ -4533,7 +4533,7 @@ trident_probe(struct pci_dev *pci_dev, c
 				printk(KERN_INFO "trident: Running on Alpha system "
 				       "type Nautilus\n");
 				ac97_data =3D ali_ac97_get(card, 0, AC97_POWER_CONTROL);
-				ali_ac97_set(card, 0, AC97_POWER_CONTROL,=20
+				ali_ac97_set(card, 0, AC97_POWER_CONTROL,
 					     ac97_data | ALI_EAPD_POWER_DOWN);
 			}
 		}
@@ -4566,7 +4566,7 @@ out_proc_fs:
 	devs =3D NULL;
 out_release_region:
 	release_region(iobase, 256);
-	return rc;=20
+	return rc;
 }
=20
 static void __devexit
@@ -4634,8 +4634,8 @@ static struct pci_driver trident_pci_dri
 static int __init
 trident_init_module(void)
 {
-	printk(KERN_INFO "Trident 4DWave/SiS 7018/ALi 5451,Tvia CyberPro "=20
-	       "5050 PCI Audio, version " DRIVER_VERSION ", " __TIME__ " "=20
+	printk(KERN_INFO "Trident 4DWave/SiS 7018/ALi 5451,Tvia CyberPro "
+	       "5050 PCI Audio, version " DRIVER_VERSION ", " __TIME__ " "
 	       __DATE__ "\n");
=20
 	return pci_register_driver(&trident_pci_driver);
_

Patches currently in -mm which might be from muli@il.ibm.com are

origin.patch
x86-64-calgary-generalize-calgary_increase_split_completion_timeout.pat=
ch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
x86-64-calgary-tighten-up-the-bitmap-locking.patch
x86-64-calgary-fold-in-redundant-functions.patch
x86_64-calgary-change-_map_single-etc-to-static.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
