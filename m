From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch added to -mm tree
Date: Fri, 22 Jan 2010 15:07:30 -0800
Message-ID: <201001222307.o0MN7UOk001806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976Ab0AVXIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 18:08:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, stefanr@s5r6.in-berlin.de


The patch titled
     scripts/get_maintainer.pl: change --sections to print in the same style as MAINTAINERS
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch

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
Subject: scripts/get_maintainer.pl: change --sections to print in the same style as MAINTAINERS
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers
+++ a/scripts/get_maintainer.pl
@@ -381,8 +381,10 @@ foreach my $file (@files) {
 			$line =~ s/\\\./\./g;       	##Convert \. to .
 			$line =~ s/\.\*/\*/g;       	##Convert .* to *
 		    }
+		    $line =~ s/^([A-Z]):/$1:\t/g;
 		    print("$line\n");
 		}
+		print("\n");
 	    }
     }
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch

