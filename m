From: akpm@osdl.org
Subject: + add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch added to -mm tree
Date: Mon, 18 Dec 2006 16:48:30 -0800
Message-ID: <200612190048.kBJ0mUc0018624@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36594 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549AbWLSAs7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:48:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, jengelh@gmx.de, randy.dunlap@oracle.com


The patch titled
     Add a new section to CodingStyle, promoting include/linux/kernel.h.
has been added to the -mm tree.  Its filename is
     add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add a new section to CodingStyle, promoting include/linux/kernel.h.
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
 1 files changed, 18 insertions(+)

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

add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch

