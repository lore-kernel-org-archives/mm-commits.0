From: akpm@linux-foundation.org
Subject: [patch 122/124] checkpatch: add another old address for the FSF
Date: Fri, 24 Feb 2017 15:01:38 -0800
Message-ID: <58b0bb52.7Vf4iuGXMEPjRZUL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39336 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751860AbdBXXBj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:01:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mawilcox@microsoft.com, joe@perches.com

From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: checkpatch: add another old address for the FSF

We still have a lot of old addresses for the FSF in the kernel.

willy@harry:~/kernel/idr$ git grep '675 Mass' |wc -l
1502
willy@harry:~/kernel/idr$ git grep '59 Temple' |wc -l
2825
willy@harry:~/kernel/idr$ git grep '51 Franklin' |wc -l
2020

Let's discourage adding the oldest one too.

Link: http://lkml.kernel.org/r/20170128173052.GA23532@bombadil.infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-another-old-address-for-the-fsf scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-another-old-address-for-the-fsf
+++ a/scripts/checkpatch.pl
@@ -2703,6 +2703,7 @@ sub process {
 
 # Check for FSF mailing addresses.
 		if ($rawline =~ /\bwrite to the Free/i ||
+		    $rawline =~ /\b675\s+Mass\s+Ave/i ||
 		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
 		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
_
