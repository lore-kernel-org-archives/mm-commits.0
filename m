From: akpm@linux-foundation.org
Subject: +
 checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch added to -mm tree
Date: Tue, 30 Jul 2013 13:35:40 -0700
Message-ID: <51f8239c.ih+Niuu177bjm+wX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016Ab3G3Ufk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 16:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@stressinduktion.org, joe@perches.com

Subject: + checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch added to -mm tree
To: joe@perches.com,hannes@stressinduktion.org
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 13:35:40 -0700


The patch titled
     Subject: checkpatch: warn when using extern with function prototypes in .h files
has been added to the -mm tree.  Its filename is
     checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Return-Path: <joe@perches.com>
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id r6P2xMsU012357
	for <akpm@localhost>; Wed, 24 Jul 2013 19:59:22 -0700
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Wed, 24 Jul 2013 19:59:22 -0700 (PDT)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTP id AF27D9A7
	for <akpm@mail.linuxfoundation.org>; Thu, 25 Jul 2013 02:59:14 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-pb0-f50.google.com (mail-pb0-f50.google.com [209.85.160.50])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id 343C81FFFD
	for <akpm@mail.linuxfoundation.org>; Thu, 25 Jul 2013 02:59:13 +0000 (UTC)
Received: by mail-pb0-f50.google.com with SMTP id wz7so173057pbc.9
        for <akpm@mail.linuxfoundation.org>; Wed, 24 Jul 2013 19:59:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:x-mailer:mime-version:content-transfer-encoding
         :delivered-to:x-gm-message-state;
        bh=HegxCR9S/6Ol8/NXFHJEqp0kOFZ1qzccL84Eae8nUis=;
        b=W3LdZSCP098FS/g9/+9FviU/F0DVnRCUYq8tC+VhyczZlOKyTv0LQ0CoQQyNQcZTWd
         NLlppFh6VztGAti+unlJMX28IQ7cWcG/M2EAFDD4wEgkxEIz4Cm5VZFKZzSC6IIfVeNW
         MNABHbWkKxuflG4Tn17q6nqWr/2M3YR1CT2g5XUfUutoxXhP4K1ql+Nz49nfMdPX2lc2
         cvxDyee98exPWoVr/YGtBFvNfRs2yFsp+JIsmTFnpm2WSJ/NfxHkaMJ8n+bLdXTdUzHk
         nguFp8PpXoUiBU0SzBfJrmCvJ2wjOYbsJYdNrpX4fsYND+wnhIhbY6DzJkuvE1ZHyEwV
         gCww==
X-Received: by 10.66.240.140 with SMTP id wa12mr46799974pac.162.1374721152928;
        Wed, 24 Jul 2013 19:59:12 -0700 (PDT)
X-Received: by 10.66.240.140 with SMTP id wa12mr46799933pac.162.1374721152333;
        Wed, 24 Jul 2013 19:59:12 -0700 (PDT)
Received: from labridge.com (perches-mx.perches.com. [206.117.179.246])
        by mx.google.com with ESMTPS id ib1si28287620pbc.190.2013.07.24.19.59.11
        for <akpm@linux-foundation.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Wed, 24 Jul 2013 19:59:12 -0700 (PDT)
Received-SPF: pass (google.com: best guess record for domain of joe@perches.com designates 206.117.179.246 as permitted sender) client-ip=206.117.179.246;
Authentication-Results: mx.google.com;
       spf=pass (google.com: best guess record for domain of joe@perches.com designates 206.117.179.246 as permitted sender) smtp.mail=joe@perches.com
Received: from [173.51.221.202] (account joe@perches.com HELO [192.168.1.152])
  by labridge.com (CommuniGate Pro SMTP 5.0.14)
  with ESMTPA id 21185239; Wed, 24 Jul 2013 19:59:11 -0700
Message-ID: <1374721150.1924.26.camel@joe-AO722>
Subject: checkpatch: Warn when using extern with function prototypes in .h files
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Hannes Frederic Sowa
	 <hannes@stressinduktion.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 24 Jul 2013 19:59:10 -0700
In-Reply-To: <20130725014732.GA10036@order.stressinduktion.org>
References: <1374602291.3387.17.camel@joe-AO722>
	 <kspuuk$k2v$1@ger.gmane.org> <1374716480.1924.18.camel@joe-AO722>
	 <20130725014732.GA10036@order.stressinduktion.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Delivered-To: akpm@linux-foundation.org
X-Gm-Message-State: ALoCoQkkQsRYHjRth62vtcP2dTWDIwQLza8w9oAlP7aNvPZVCU8/74ko7De9B0TFmFBM8qdCEjbQlYxIHSzNihSjxkKeB0LTWYHEidJ2R+XDo/yIU8CxNvnZhFzBMoEaX+PVkbAAa74lFaIaja01gGa6fdujyd1/lw==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW
	autolearn=ham version=3.3.1
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
	smtp1.linux-foundation.org

Using the extern keyword on function prototypes is superfluous
visual noise so suggest removing it.

Using extern can cause unnecessary line wrapping at 80 columns
and unnecessarily long multi-line function prototypes.

Suggested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Joe Perches <joe@perches.com>
---
On Thu, 2013-07-25 at 03:47 +0200, Hannes Frederic Sowa wrote:
> On Wed, Jul 24, 2013 at 06:41:20PM -0700, Joe Perches wrote:
> > On Thu, 2013-07-25 at 01:27 +0000, Cong Wang wrote:
> > > On Tue, 23 Jul 2013 at 17:58 GMT, Joe Perches <joe@perches.com> wrote:
> > > > Function prototypes don't need to be declared
> > > > extern in .h files.  It's assumed by the compiler
> > > > and is as unnecessary as using auto is when
> > > > declaring automatic/local variables in a block.
> > > Since we all know this, why bother it?
> > If everyone knew this, new ones wouldn't be added.
> > But a lot are.
> Couldn't checkpatch take care of these?

checkpatch doesn't work well for multiple lines so
this doesn't work on things like
	extern unsigned long
	foo(type bar);
but it does for the single line function prototypes.

Using --fix removes them.

 scripts/checkpatch.pl | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6918517..23126d4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3866,6 +3866,16 @@ sub process {
 			}
 		}
 
+# check for new externs in .h files.
+		if ($realfile =~ /\.h$/ &&
+		    $line =~ /^\+\s*(extern\s+)$Type\s*$Ident\s*\(/s) {
+			if (WARN("AVOID_EXTERNS",
+				 "extern prototypes should be avoided in .h files\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/(.*)\bextern\b\s*(.*)/$1$2/;
+			}
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
-- 
1.8.1.2.459.gbcd45b4.dirty



Patches currently in -mm which might be from joe@perches.com are

maintainers-dynamic-debug-jasons-not-there.patch
printk-move-to-separate-directory-for-easier-modification.patch
printk-move-to-separate-directory-for-easier-modification-fix.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
checkpatch-check-for-duplicate-signatures.patch
checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
pktcdvd-convert-pr_notice-to-pkt_notice.patch
pktcdvd-convert-pr_info-to-pkt_info.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch
linux-next.patch

