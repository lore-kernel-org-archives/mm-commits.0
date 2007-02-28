From: akpm@linux-foundation.org
Subject: - x86-dont-probe-for-ddc-on-vbe12.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:53:56 -0800
Message-ID: <200702282353.l1SNru2E031160@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48452 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658AbXB1XyP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zwane@infradead.org, ak@suse.de, hpa@zytor.com, randy.dunlap@oracle.com, tobias.hain@gmx.de, mm-commits@vger.kernel.org


The patch titled
     x86: don't probe for DDC on VBE1.2
has been removed from the -mm tree.  Its filename was
     x86-dont-probe-for-ddc-on-vbe12.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: don't probe for DDC on VBE1.2
From: Zwane Mwaikambo <zwane@infradead.org>
Return-Path: <zwane@infradead.org>
Received: from localhost (bix [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id l1H8ZWfJ027389
	for <akpm@localhost>; Sat, 17 Feb 2007 00:35:32 -0800
Received: from bix [127.0.0.1]
	by localhost with POP3 (fetchmail-6.2.0)
	for akpm@localhost (single-drop); Sat, 17 Feb 2007 00:35:32 -0800 (PST)
Received: from smtp1.osdl.org (smtp1.osdl.org [65.172.181.25])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id l1H8aAmC022980
	for <akpm@mail.gateway.osdl.net>; Sat, 17 Feb 2007 00:36:10 -0800
Received: from pd2mo2so.prod.shaw.ca (shawidc-mo1.cg.shawcable.net [24.71.223.10])
	by smtp1.osdl.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l1H8a3aK020841
	for <akpm@linux-foundation.org>; Sat, 17 Feb 2007 00:36:04 -0800
Received: from pd3mr4so.prod.shaw.ca
 (pd3mr4so-qfe3.prod.shaw.ca [10.0.141.180]) by l-daemon
 (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JDL00EKEMK3S6A0@l-daemon> for akpm@linux-foundation.org; Sat,
 17 Feb 2007 01:36:03 -0700 (MST)
Received: from pn2ml7so.prod.shaw.ca ([10.0.121.151])
 by pd3mr4so.prod.shaw.ca (Sun Java System Messaging Server 6.2-7.05 (built Sep
 5 2006)) with ESMTP id <0JDL00F1GMK3CX60@pd3mr4so.prod.shaw.ca> for
 akpm@linux-foundation.org; Sat, 17 Feb 2007 01:36:04 -0700 (MST)
Received: from montezuma.fsmlabs.com ([24.85.144.101])
 by l-daemon (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JDL00162MJULPH1@l-daemon> for akpm@linux-foundation.org; Sat,
 17 Feb 2007 01:35:58 -0700 (MST)
Received: from montezuma.fsmlabs.com (zwane@localhost [127.0.0.1])
	by montezuma.fsmlabs.com (8.13.8/8.13.8/Debian-2)
 with ESMTP id l1H8Zrqd011418; Sat, 17 Feb 2007 00:35:53 -0800
Received: from localhost (zwane@localhost)
	by montezuma.fsmlabs.com (8.13.8/8.13.8/Submit) with ESMTP id l1H8Zq8v011413;
 Sat, 17 Feb 2007 00:35:53 -0800
Date: Sat, 17 Feb 2007 00:35:52 -0800 (PST)
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
In-reply-to: <20070216102206.343e0b0d.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
        Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <Pine.LNX.4.64.0702170024270.11321@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
 <20070215205658.56096f97.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702152134190.12571@montezuma.fsmlabs.com>
 <20070215214506.f795acc4.akpm@linux-foundation.org>
 <20070215215125.9161e3dc.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702152158210.12571@montezuma.fsmlabs.com>
 <20070215230243.515ec6b3.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702160500210.31650@montezuma.fsmlabs.com>
 <20070216102206.343e0b0d.akpm@linux-foundation.org>
X-Authentication-warning: montezuma.fsmlabs.com: zwane owned process doing -bs
Received-SPF: none (domain of zwane@infradead.org does not designate permitted sender hosts)
X-MIMEDefang-Filter: osdl$Revision: 1.176 $
X-Scanned-By: MIMEDefang 2.53 on 65.172.181.25
X-Spam-Checker-Version: SpamAssassin 3.0.2 (2004-11-16) on bix
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=AWL,BAYES_00,
	FORGED_RCVD_HELO autolearn=ham version=3.0.2

On Fri, 16 Feb 2007, Andrew Morton wrote:

> On Fri, 16 Feb 2007 06:39:45 -0800 (PST) Zwane Mwaikambo <zwane@infradead.org> wrote:
> 
> > On Thu, 15 Feb 2007, Andrew Morton wrote:
> > 
> > > It's not an X problem - the screen is black immediately upon loading the
> > > kernel.
> > > 
> > > But I guess you knew that and you're just after display info:
> > > http://userweb.kernel.org/~akpm/Xorg.0.log.txt
> > 
> > Thanks, the X log told me your VBE version. I tried to reproduce it on my 
> > thinkpad which seems to have a very similar video setup to no avail, Could 
> > you test the following on the VAIO? If this isn't the case, i suspect i'm 
> > corrupting your modelist.
> 
> It's still all black.

Ok it looks like i was corrupting the modelist. The following should take 
care of your VAIO, but i haven't tested the failure case as Tobias is away 
this weekend.

Index: linux-2.6.20-mm1/arch/i386/boot/video.S
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-mm1/arch/i386/boot/video.S,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 video.S
--- linux-2.6.20-mm1/arch/i386/boot/video.S	15 Feb 2007 17:35:57 -0000	1.1.1.1
+++ linux-2.6.20-mm1/arch/i386/boot/video.S	17 Feb 2007 08:29:11 -0000
@@ -571,6 +571,16 @@ setr1:	lodsw
 	jmp	_m_s
 
 check_vesa:
+#ifdef CONFIG_FIRMWARE_EDID
+	leaw	modelist+1024, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	cmpw	$0x004f, %ax
+	jnz	setbad
+	
+	movw	4(%di), %ax
+	movw	%ax, vbe_version
+#endif
 	leaw	modelist+1024, %di
 	subb	$VIDEO_FIRST_VESA>>8, %bh
 	movw	%bx, %cx			# Get mode information structure
@@ -1945,6 +1955,9 @@ store_edid:
 	rep
 	stosl
 
+	cmpw	$0x0200, vbe_version		# only do EDID on >= VBE2.0
+	jl	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
@@ -1987,6 +2000,7 @@ do_restore:	.byte	0	# Screen contents al
 svga_prefix:	.byte	VIDEO_FIRST_BIOS>>8	# Default prefix for BIOS modes
 graphic_mode:	.byte	0	# Graphic mode with a linear frame buffer
 dac_size:	.byte	6	# DAC bit depth
+vbe_version:	.word	0	# VBE bios version
 
 # Status messages
 keymsg:		.ascii	"Press <RETURN> to see video modes available, "
Index: linux-2.6.20-mm1/arch/x86_64/boot/video.S
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-mm1/arch/x86_64/boot/video.S,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 video.S
--- linux-2.6.20-mm1/arch/x86_64/boot/video.S	15 Feb 2007 17:36:18 -0000	1.1.1.1
+++ linux-2.6.20-mm1/arch/x86_64/boot/video.S	17 Feb 2007 08:29:11 -0000
@@ -571,6 +571,16 @@ setr1:	lodsw
 	jmp	_m_s
 
 check_vesa:
+#ifdef CONFIG_FIRMWARE_EDID
+	leaw	modelist+1024, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	cmpw	$0x004f, %ax
+	jnz	setbad
+	
+	movw	4(%di), %ax
+	movw	%ax, vbe_version
+#endif
 	leaw	modelist+1024, %di
 	subb	$VIDEO_FIRST_VESA>>8, %bh
 	movw	%bx, %cx			# Get mode information structure
@@ -1945,6 +1955,9 @@ store_edid:
 	rep
 	stosl
 
+	cmpw	$0x0200, vbe_version		# only do EDID on >= VBE2.0
+	jl	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
@@ -1987,6 +2000,7 @@ do_restore:	.byte	0	# Screen contents al
 svga_prefix:	.byte	VIDEO_FIRST_BIOS>>8	# Default prefix for BIOS modes
 graphic_mode:	.byte	0	# Graphic mode with a linear frame buffer
 dac_size:	.byte	6	# DAC bit depth
+vbe_version:	.word	0	# VBE bios version
 
 # Status messages
 keymsg:		.ascii	"Press <RETURN> to see video modes available, "

Patches currently in -mm which might be from zwane@infradead.org are
