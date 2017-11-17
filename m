From: akpm@linux-foundation.org
Subject: [patch 22/94] include/linux/compiler-clang.h: handle
 randomizable anonymous structs
Date: Fri, 17 Nov 2017 15:27:28 -0800
Message-ID: <20171117232728.8XzkPS_EU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423261AbdKQX1a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@fb.com, gregkh@linuxfoundation.org, kstewart@linuxfoundation.org, mm-commits@vger.kernel.org, naveen.n.rao@linux.vnet.ibm.com, rientjes@google.com, sandipan@linux.vnet.ibm.com, tglx@linutronix.de, torvalds@linux-foundation.org

From: Sandipan Das <sandipan@linux.vnet.ibm.com>
Subject: include/linux/compiler-clang.h: handle randomizable anonymous structs

The GCC randomize layout plugin can randomize the member offsets of
sensitive kernel data structures.  To use this feature, certain
annotations and members are added to the structures which affect the
member offsets even if this plugin is not used.

All of these structures are completely randomized, except for task_struct
which leaves out some of its members.  All the other members are wrapped
within an anonymous struct with the __randomize_layout attribute.  This is
done using the randomized_struct_fields_start and
randomized_struct_fields_end defines.  When the plugin is disabled, the
behaviour of this attribute can vary based on the GCC version.  For GCC
5.1+, this attribute maps to __designated_init otherwise it is just an
empty define but the anonymous structure is still present.  For other
compilers, both randomized_struct_fields_start and
randomized_struct_fields_end default to empty defines meaning the
anonymous structure is not introduced at all.  So, if a module compiled
with Clang, such as a BPF program, needs to access task_struct fields such
as pid and comm, the offsets of these members as recognized by Clang are
different from those recognized by modules compiled with GCC.  If GCC 4.6+
is used to build the kernel, this can be solved by introducing appropriate
defines for Clang so that the anonymous structure is seen when determining
the offsets for the members.

Link: http://lkml.kernel.org/r/20171109064645.25581-1-sandipan@linux.vnet.ibm.com
Signed-off-by: Sandipan Das <sandipan@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Alexei Starovoitov <ast@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/compiler-clang.h~compiler-clang-handle-randomizable-anonymous-structs include/linux/compiler-clang.h
--- a/include/linux/compiler-clang.h~compiler-clang-handle-randomizable-anonymous-structs
+++ a/include/linux/compiler-clang.h
@@ -16,3 +16,6 @@
  * with any version that can compile the kernel
  */
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
+
+#define randomized_struct_fields_start	struct {
+#define randomized_struct_fields_end	};
_
