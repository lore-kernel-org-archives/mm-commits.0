From: akpm@linux-foundation.org
Subject: [nacked] init-kconfig-enable-o3-for-all-arches.patch
 removed from -mm tree
Date: Thu, 09 Jan 2020 14:02:22 -0800
Message-ID: <20200109220222.hQcRs-gox%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbgAIWCX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 17:02:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dhowells@redhat.com, ebiederm@xmission.com, gregkh@linuxfoundation.org, jeyu@kernel.org, joel@joelfernandes.org, krzk@kernel.org, mchehab+samsung@kernel.org, mm-commits@vger.kernel.org, oleksandr@redhat.com, patrick.bellasi@arm.com, tj@kernel.org, yamada.masahiro@socionext.com


The patch titled
     Subject: init/Kconfig: enable -O3 for all arches
has been removed from the -mm tree.  Its filename was
     init-kconfig-enable-o3-for-all-arches.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: init/Kconfig: enable -O3 for all arches

Building a kernel with -O3 may help in hunting bugs like [1] and thus
using this switch should not be restricted to one specific arch only.

So let's expose it.  If for some reasone we have to hide it, lets hide it
under EXPERT.

The commit is made against next-20191210 tag.

[1] https://lore.kernel.org/lkml/673b885183fb64f1cbb3ed2387524077@natalenko.name/

Link: http://lkml.kernel.org/r/20191210145657.105808-1-oleksandr@redhat.com
Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/init/Kconfig~init-kconfig-enable-o3-for-all-arches
+++ a/init/Kconfig
@@ -1228,7 +1228,6 @@ config CC_OPTIMIZE_FOR_PERFORMANCE
 
 config CC_OPTIMIZE_FOR_PERFORMANCE_O3
 	bool "Optimize more for performance (-O3)"
-	depends on ARC
 	imply CC_DISABLE_WARN_MAYBE_UNINITIALIZED  # avoid false positives
 	help
 	  Choosing this option will pass "-O3" to your compiler to optimize
_

Patches currently in -mm which might be from oleksandr@redhat.com are
