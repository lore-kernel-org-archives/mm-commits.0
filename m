From: akpm@linux-foundation.org
Subject: + docbook-fix-drivers-base-class-warning.patch added to -mm tree
Date: Wed, 30 Jan 2008 14:02:53 -0800
Message-ID: <200801302202.m0UM2rvb027039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311AbYA3WDe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 17:03:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     docbook: fix drivers/base/class warning
has been added to the -mm tree.  Its filename is
     docbook-fix-drivers-base-class-warning.patch

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
Subject: docbook: fix drivers/base/class warning
From: Randy Dunlap <randy.dunlap@oracle.com>
Return-Path: <randy.dunlap@oracle.com>
Received: from localhost (bix [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id m0UJp4uC015938
	for <akpm@localhost>; Wed, 30 Jan 2008 11:51:06 -0800
Received: from imap1.linux-foundation.org [207.189.120.55]
	by localhost with POP3 (fetchmail-6.2.5)
	for akpm@localhost (single-drop); Wed, 30 Jan 2008 11:51:06 -0800 (PST)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [207.189.120.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m0UJqVVL021782;
	Wed, 30 Jan 2008 11:52:31 -0800
Received: from rgminet01.oracle.com (rgminet01.oracle.com [148.87.113.118])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m0UJqKpC024272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Wed, 30 Jan 2008 11:52:26 -0800
Received: from agmgw1.us.oracle.com (agmgw1.us.oracle.com [152.68.180.212])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id m0UJq8R0003236;
	Wed, 30 Jan 2008 12:52:09 -0700
Received: from acsmt353.oracle.com (acsmt353.oracle.com [141.146.40.153])
	by agmgw1.us.oracle.com (Switch-3.2.0/Switch-3.2.0) with ESMTP id m0UJhJER009828;
	Wed, 30 Jan 2008 12:52:08 -0700
Received: from pool-96-225-192-120.ptldor.fios.verizon.net by acsmt359.oracle.com
	with ESMTP id 7117109321201722669; Wed, 30 Jan 2008 13:51:09 -0600
Date: Wed, 30 Jan 2008 11:51:08 -0800
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>, akpm <akpm@linux-foundation.org>,
        torvalds
 <torvalds@linux-foundation.org>
Subject: [PATCH] docbook: fix drivers/base/class warning
Message-Id: <20080130115108.2df9ade6.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Received-SPF: none (domain of randy.dunlap@oracle.com does not designate permitted sender hosts)
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.53 on 207.189.120.13
X-Spam-Checker-Version: SpamAssassin 3.0.2 (2004-11-16) on bix
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=2.0 tests=AWL autolearn=ham 
	version=3.0.2


Fix kernel-doc empty line warning:
Warning(linux-2.6.24-git8//drivers/base/class.c:866): bad line:

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-git8.orig/drivers/base/class.c
+++ linux-2.6.24-git8/drivers/base/class.c
@@ -863,7 +863,7 @@ EXPORT_SYMBOL_GPL(class_for_each_device)
  * The callback should return 0 if the device doesn't match and non-zero
  * if it does.  If the callback returns non-zero, this function will
  * return to the caller and not iterate over any more devices.
-
+ *
  * Note, you will need to drop the reference with put_device() after use.
  *
  * We hold class->sem in this function, so it can not be

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
docbook-fix-drivers-base-class-warning.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
profile-likely-unlikely-macros.patch
