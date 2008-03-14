From: akpm@linux-foundation.org
Subject: + kprobes-update-document-about-batch-registration.patch added to -mm tree
Date: Fri, 14 Mar 2008 14:06:43 -0700
Message-ID: <200803142106.m2EL6hFS019386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbYCNVM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 17:12:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, davem@davemloft.net, fche@redhat.com, jkenisto@us.ibm.com, prasanna@in.ibm.com, shaohua.li@intel.com


The patch titled
     kprobes: update document about batch registration
has been added to the -mm tree.  Its filename is
     kprobes-update-document-about-batch-registration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: update document about batch registration
From: Masami Hiramatsu <mhiramat@redhat.com>

Add the description of batch registration interfaces to
Documentation/kprobes.txt.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt |   51 +++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 4 deletions(-)

diff -puN Documentation/kprobes.txt~kprobes-update-document-about-batch-registration Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~kprobes-update-document-about-batch-registration
+++ a/Documentation/kprobes.txt
@@ -37,6 +37,11 @@ registration function such as register_k
 the probe is to be inserted and what handler is to be called when
 the probe is hit.
 
+There are also register_/unregister_*probes() functions for batch
+registration/unregistration of a group of *probes. These functions
+can speed up unregistration process when you have to unregister
+a lot of probes at once.
+
 The next three subsections explain how the different types of
 probes work.  They explain certain things that you'll need to
 know in order to make the best use of Kprobes -- e.g., the
@@ -190,10 +195,11 @@ code mapping.
 4. API Reference
 
 The Kprobes API includes a "register" function and an "unregister"
-function for each type of probe.  Here are terse, mini-man-page
-specifications for these functions and the associated probe handlers
-that you'll write.  See the files in the samples/kprobes/ sub-directory
-for examples.
+function for each type of probe. The API also includes "register_*probes"
+and "unregister_*probes" functions for (un)registering arrays of probes.
+Here are terse, mini-man-page specifications for these functions and
+the associated probe handlers that you'll write. See the files in the
+samples/kprobes/ sub-directory for examples.
 
 4.1 register_kprobe
 
@@ -319,6 +325,43 @@ void unregister_kretprobe(struct kretpro
 Removes the specified probe.  The unregister function can be called
 at any time after the probe has been registered.
 
+NOTE:
+If the functions find an incorrect probe (ex. an unregistered probe),
+they clear the addr field of the probe.
+
+4.5 register_*probes
+
+#include <linux/kprobes.h>
+int register_kprobes(struct kprobe **kps, int num);
+int register_kretprobes(struct kretprobe **rps, int num);
+int register_jprobes(struct jprobe **jps, int num);
+
+Registers each of the num probes in the specified array.  If any
+error occurs during registration, all probes in the array, up to
+the bad probe, are safely unregistered before the register_*probes
+function returns.
+- kps/rps/jps: an array of pointers to *probe data structures
+- num: the number of the array entries.
+
+NOTE:
+You have to allocate(or define) an array of pointers and set all
+of the array entries before using these functions.
+
+4.6 unregister_*probes
+
+#include <linux/kprobes.h>
+void unregister_kprobes(struct kprobe **kps, int num);
+void unregister_kretprobes(struct kretprobe **rps, int num);
+void unregister_jprobes(struct jprobe **jps, int num);
+
+Removes each of the num probes in the specified array at once.
+
+NOTE:
+If the functions find some incorrect probes (ex. unregistered
+probes) in the specified array, they clear the addr field of those
+incorrect probes. However, other probes in the array are
+unregistered correctly.
+
 5. Kprobes Features and Limitations
 
 Kprobes allows multiple probes at the same address.  Currently,
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-kprobe-booster-for-ia64.patch
kprobes-kprobe-booster-for-ia64-fix.patch
listh-add-list_singleton.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

