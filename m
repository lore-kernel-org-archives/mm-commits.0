From: akpm@linux-foundation.org
Subject: + checkpatchpl-check-for-the-fsf-mailing-address.patch added to
 -mm tree
Date: Mon, 07 Oct 2013 16:37:02 -0700
Message-ID: <5253459e.0x2J/mHhINkSFQ2/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3JGXhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 19:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, gregkh@linuxfoundation.org, josh@joshtriplett.org

Subject: + checkpatchpl-check-for-the-fsf-mailing-address.patch added to -mm tree
To: josh@joshtriplett.org,gregkh@linuxfoundation.org,joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 16:37:02 -0700


The patch titled
     Subject: checkpatch.pl: check for the FSF mailing address
has been added to the -mm tree.  Its filename is
     checkpatchpl-check-for-the-fsf-mailing-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatchpl-check-for-the-fsf-mailing-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatchpl-check-for-the-fsf-mailing-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: checkpatch.pl: check for the FSF mailing address

Kernel maintainers reject new instances of the GPL boilerplate paragraph
directing people to write to the FSF for a copy of the GPL, since the FSF
has moved in the past and may do so again.

Make this an error for new code, but just a --strict CHK in --file mode;
anyone interested in doing tree-wide cleanups of this form can enable this
test explicitly.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-check-for-the-fsf-mailing-address scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-check-for-the-fsf-mailing-address
+++ a/scripts/checkpatch.pl
@@ -1962,6 +1962,18 @@ sub process {
 			$rpt_cleaners = 1;
 		}
 
+# Check for FSF mailing addresses.
+		if ($rawline =~ /You should have received a copy/ ||
+		    $rawline =~ /write to the Free Software/ ||
+		    $rawline =~ /59 Temple Place/ ||
+		    $rawline =~ /51 Franklin Street/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			my $msg_type = \&ERROR;
+			$msg_type = \&CHK if ($file);
+			&{$msg_type}("FSF_MAILING_ADDRESS",
+				"Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
+		}
+
 # check for Kconfig help text having a real description
 # Only applies when adding the entry originally, after that we do not have
 # sufficient context to determine whether it is indeed long enough.
_

Patches currently in -mm which might be from josh@joshtriplett.org are

checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
linux-next.patch

