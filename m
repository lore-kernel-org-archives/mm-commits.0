From: akpm@linux-foundation.org
Subject: +
 documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols.patch
 added to -mm tree
Date: Fri, 01 Nov 2013 14:36:06 -0700
Message-ID: <52741ec6.ma7VyrhEvyBWO58R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3KAVgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 17:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, richard.weinberger@gmail.com, hpa@zytor.com, gregkh@linuxfoundation.org, boyu.mt@taobao.com, josh@joshtriplett.org

Subject: + documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols.patch added to -mm tree
To: josh@joshtriplett.org,boyu.mt@taobao.com,gregkh@linuxfoundation.org,hpa@zytor.com,richard.weinberger@gmail.com,rob@landley.net
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 14:36:06 -0700


The patch titled
     Subject: Documentation/ABI: document the non-ABI status of Kconfig and symbols
has been added to the -mm tree.  Its filename is
     documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols.patch

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
Subject: Documentation/ABI: document the non-ABI status of Kconfig and symbols

Discussion at Kernel Summit made it clear that the presence or absence of
specific Kconfig symbols are not considered ABI, and that no userspace (or
bootloader, etc) should rely on them.

In addition, kernel-internal symbols are well established as non-ABI, per
Documentation/stable_api_nonsense.txt.

Document both of these in Documentation/ABI/README, in a new section for
notable bits of non-ABI.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Rob Landley <rob@landley.net>
Cc: Tao Ma <boyu.mt@taobao.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/README |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN Documentation/ABI/README~documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols Documentation/ABI/README
--- a/Documentation/ABI/README~documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols
+++ a/Documentation/ABI/README
@@ -72,3 +72,16 @@ kernel tree without going through the ob
 
 It's up to the developer to place their interfaces in the category they
 wish for it to start out in.
+
+
+Notable bits of non-ABI, which should not under any circumstances be considered
+stable:
+
+- Kconfig.  Userspace should not rely on the presence or absence of any
+  particular Kconfig symbol, in /proc/config.gz, in the copy of .config
+  commonly installed to /boot, or in any invocation of the kernel build
+  process.
+
+- Kernel-internal symbols.  Do not rely on the presence, absence, location, or
+  type of any kernel symbol, either in System.map files or the kernel binary
+  itself.  See Documentation/stable_api_nonsense.txt.
_

Patches currently in -mm which might be from josh@joshtriplett.org are

checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols.patch
scripts-bloat-o-meter-ignore-changes-in-the-size-of-linux_banner.patch
scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing.patch
linux-next.patch

