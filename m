From: akpm@osdl.org
Subject: - add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:11 -0800
Message-ID: <200612230754.kBN7sBsV010189@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49740 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbWLWHyg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, jengelh@gmx.de, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Add a new section to CodingStyle, promoting include/linux/kernel.h
has been removed from the -mm tree.  Its filename was
     add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add a new section to CodingStyle, promoting include/linux/kernel.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Add a new section to the CodingStyle file, encouraging people not to
re-invent available kernel macros such as ARRAY_SIZE(), FIELD_SIZEOF(),
min() and max(), among others.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/CodingStyle |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN Documentation/CodingStyle~add-a-new-section-to-codingstyle-promoting-include-linux-kernelh Documentation/CodingStyle
--- a/Documentation/CodingStyle~add-a-new-section-to-codingstyle-promoting-include-linux-kernelh
+++ a/Documentation/CodingStyle
@@ -682,6 +682,24 @@ result.  Typical examples would be funct
 NULL or the ERR_PTR mechanism to report failure.
 
 
+		Chapter 17:  Don't re-invent the kernel macros
+
+The header file include/linux/kernel.h contains a number of macros that
+you should use, rather than explicitly coding some variant of them yourself.
+For example, if you need to calculate the length of an array, take advantage
+of the macro
+
+  #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+Similarly, if you need to calculate the size of some structure member, use
+
+  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
+
+There are also min() and max() macros that do strict type checking if you
+need them.  Feel free to peruse that header file to see what else is already
+defined that you shouldn't reproduce in your code.
+
+
 
 		Appendix I: References
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch

