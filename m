From: akpm@linux-foundation.org
Subject: + res_counter-update-documentation.patch added to -mm tree
Date: Thu, 09 Apr 2009 14:39:11 -0700
Message-ID: <200904092139.n39LdBWt007558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758526AbZDIVmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com, balbir@linux.vnet.ibm.com, menage@google.com, xemul@openvz.org


The patch titled
     res_counter: update documentation
has been added to the -mm tree.  Its filename is
     res_counter-update-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: res_counter: update documentation
From: Andrea Righi <righi.andrea@gmail.com>

After the introduction of resource counters hierarchies
(28dbc4b6a01fb579a9441c7b81e3d3413dc452df) the prototypes of
res_counter_init() and res_counter_charge() have been changed.

Keep the documentation consistent with the actual function prototypes.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/resource_counter.txt |   27 ++++++++++++++-----
 1 file changed, 21 insertions(+), 6 deletions(-)

diff -puN Documentation/cgroups/resource_counter.txt~res_counter-update-documentation Documentation/cgroups/resource_counter.txt
--- a/Documentation/cgroups/resource_counter.txt~res_counter-update-documentation
+++ a/Documentation/cgroups/resource_counter.txt
@@ -47,13 +47,18 @@ to work with it.
 
 2. Basic accounting routines
 
- a. void res_counter_init(struct res_counter *rc)
+ a. void res_counter_init(struct res_counter *rc,
+				struct res_counter *rc_parent)
 
  	Initializes the resource counter. As usual, should be the first
 	routine called for a new counter.
 
- b. int res_counter_charge[_locked]
-			(struct res_counter *rc, unsigned long val)
+	The struct res_counter *parent can be used to define a hierarchical
+	child -> parent relationship directly in the res_counter structure,
+	NULL can be used to define no relationship.
+
+ c. int res_counter_charge(struct res_counter *rc, unsigned long val,
+				struct res_counter **limit_fail_at)
 
 	When a resource is about to be allocated it has to be accounted
 	with the appropriate resource counter (controller should determine
@@ -67,15 +72,25 @@ to work with it.
 	  * if the charging is performed first, then it should be uncharged
 	    on error path (if the one is called).
 
- c. void res_counter_uncharge[_locked]
+	If the charging fails and a hierarchical dependency exists, the
+	limit_fail_at parameter is set to the particular res_counter element
+	where the charging failed.
+
+ d. int res_counter_charge_locked
+			(struct res_counter *rc, unsigned long val)
+
+	The same as res_counter_charge(), but it must not acquire/release the
+	res_counter->lock internally (it must be called with res_counter->lock
+	held).
+
+ e. void res_counter_uncharge[_locked]
 			(struct res_counter *rc, unsigned long val)
 
 	When a resource is released (freed) it should be de-accounted
 	from the resource counter it was accounted to.  This is called
 	"uncharging".
 
-    The _locked routines imply that the res_counter->lock is taken.
