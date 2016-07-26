From: akpm@linux-foundation.org
Subject: [patch 033/126] include/linux/mmdebug.h: add VM_WARN which maps
 to WARN()
Date: Tue, 26 Jul 2016 15:22:36 -0700
Message-ID: <5797e2ac.eTp2kf686DTxuwdM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117AbcGZWWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, mpe@ellerman.id.au

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: include/linux/mmdebug.h: add VM_WARN which maps to WARN()

This enables us to do VM_WARN(condition, "warn message");

Link: http://lkml.kernel.org/r/1464692688-6612-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mmdebug.h~mm-debug-add-vm_warn-which-maps-to-warn include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-debug-add-vm_warn-which-maps-to-warn
+++ a/include/linux/mmdebug.h
@@ -39,6 +39,7 @@ void dump_mm(const struct mm_struct *mm)
 #define VM_WARN_ON(cond) WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
+#define VM_WARN(cond, format...) WARN(cond, format)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
@@ -47,6 +48,7 @@ void dump_mm(const struct mm_struct *mm)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #endif
 
 #ifdef CONFIG_DEBUG_VIRTUAL
_
