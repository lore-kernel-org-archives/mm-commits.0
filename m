From: akpm@linux-foundation.org
Subject: + documentation-update-debugobjects-doc.patch added to -mm tree
Date: Fri, 22 Apr 2016 13:02:12 -0700
Message-ID: <571a8344.MHHpETyIf35c1wFu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbcDVUCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update debugobjects doc
has been added to the -mm tree.  Its filename is
     documentation-update-debugobjects-doc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-update-debugobjects-doc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-update-debugobjects-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Du, Changbin" <changbin.du@intel.com>
Subject: Documentation: update debugobjects doc

Update documentation creangponding to change(debugobjects: make
fixup functions return bool instead of int).

Signed-off-by: Du, Changbin <changbin.du@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/debugobjects.tmpl |   26 +++++++++++-----------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN Documentation/DocBook/debugobjects.tmpl~documentation-update-debugobjects-doc Documentation/DocBook/debugobjects.tmpl
--- a/Documentation/DocBook/debugobjects.tmpl~documentation-update-debugobjects-doc
+++ a/Documentation/DocBook/debugobjects.tmpl
@@ -316,8 +316,8 @@
 	</itemizedlist>
       </para>
       <para>
-	The function returns 1 when the fixup was successful,
-	otherwise 0. The return value is used to update the
+	The function returns true when the fixup was successful,
+	otherwise false. The return value is used to update the
 	statistics.
       </para>
       <para>
@@ -341,8 +341,8 @@
 	</itemizedlist>
       </para>
       <para>
-	The function returns 1 when the fixup was successful,
-	otherwise 0. The return value is used to update the
+	The function returns true when the fixup was successful,
+	otherwise false. The return value is used to update the
 	statistics.
       </para>
       <para>
@@ -359,7 +359,8 @@
 	statically initialized object or not. In case it is it calls
 	debug_object_init() and debug_object_activate() to make the
 	object known to the tracker and marked active. In this case
-	the function should return 0 because this is not a real fixup.
+	the function should return false because this is not a real
+	fixup.
       </para>
     </sect1>
 
@@ -376,8 +377,8 @@
 	</itemizedlist>
       </para>
       <para>
-	The function returns 1 when the fixup was successful,
-	otherwise 0. The return value is used to update the
+	The function returns true when the fixup was successful,
+	otherwise false. The return value is used to update the
 	statistics.
       </para>
     </sect1>
@@ -397,8 +398,8 @@
 	</itemizedlist>
       </para>
       <para>
-	The function returns 1 when the fixup was successful,
-	otherwise 0. The return value is used to update the
+	The function returns true when the fixup was successful,
+	otherwise false. The return value is used to update the
 	statistics.
       </para>
     </sect1>
@@ -414,8 +415,8 @@
 	debug bucket.
       </para>
       <para>
-	The function returns 1 when the fixup was successful,
-	otherwise 0. The return value is used to update the
+	The function returns true when the fixup was successful,
+	otherwise false. The return value is used to update the
 	statistics.
       </para>
       <para>
@@ -427,7 +428,8 @@
 	case. The fixup function should check if this is a legitimate
 	case of a statically initialized object or not. In this case only
 	debug_object_init() should be called to make the object known to
-	the tracker. Then the function should return 0 because this is not
+	the tracker. Then the function should return false because this
+	is not
 	a real fixup.
       </para>
     </sect1>
_

Patches currently in -mm which might be from changbin.du@intel.com are

debugobjects-make-fixup-functions-return-bool-instead-of-int.patch
debugobjects-correct-the-usage-of-fixup-call-results.patch
workqueue-update-debugobjects-fixup-callbacks-return-type.patch
timer-update-debugobjects-fixup-callbacks-return-type.patch
rcu-update-debugobjects-fixup-callbacks-return-type.patch
percpu_counter-update-debugobjects-fixup-callbacks-return-type.patch
documentation-update-debugobjects-doc.patch

