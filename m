From: akpm@linux-foundation.org
Subject: [merged] python-change-scripts-to-use-system-python-instead-of-env.patch removed from -mm tree
Date: Mon, 01 Feb 2010 10:38:58 -0800
Message-ID: <201002011838.o11Icw2D004886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755678Ab0BASmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 13:42:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, kyle@mcmartin.ca, mmarek@suse.cz, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     scripts: python: change scripts to use system python instead of env
has been removed from the -mm tree.  Its filename was
     python-change-scripts-to-use-system-python-instead-of-env.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts: python: change scripts to use system python instead of env
From: Don Zickus <dzickus@redhat.com>

Just a small change to a couple of scripts to go from

 #!/usr/bin/env python

to

 #!/usr/bin/python

This shouldn't effect anyone, unless they don't install python there.

In preparation for python3, Fedora is doing a big push to change the
scripts to use the system python.  This allows developers to put the
python3 in their path without fear of breaking existing scripts.

Now I am pretty sure anyone using python3 for testing purposes will
probably not run any of the scripts I changed, but Fedora has this
automated tool that checks for this stuff so I thought I would try to push
it upstream.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/scripts/unwcheck.py  |    2 +-
 scripts/rt-tester/rt-tester.py |    2 +-
 scripts/show_delta             |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/ia64/scripts/unwcheck.py~python-change-scripts-to-use-system-python-instead-of-env arch/ia64/scripts/unwcheck.py
--- a/arch/ia64/scripts/unwcheck.py~python-change-scripts-to-use-system-python-instead-of-env
+++ a/arch/ia64/scripts/unwcheck.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/python
 #
 # Usage: unwcheck.py FILE
 #
diff -puN scripts/rt-tester/rt-tester.py~python-change-scripts-to-use-system-python-instead-of-env scripts/rt-tester/rt-tester.py
--- a/scripts/rt-tester/rt-tester.py~python-change-scripts-to-use-system-python-instead-of-env
+++ a/scripts/rt-tester/rt-tester.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/python
 #
 # rt-mutex tester
 #
diff -puN scripts/show_delta~python-change-scripts-to-use-system-python-instead-of-env scripts/show_delta
--- a/scripts/show_delta~python-change-scripts-to-use-system-python-instead-of-env
+++ a/scripts/show_delta
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/python
 #
 # show_deltas: Read list of printk messages instrumented with
 # time data, and format with time deltas.
_

Patches currently in -mm which might be from dzickus@redhat.com are

linux-next.patch

