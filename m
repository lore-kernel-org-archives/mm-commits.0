From: akpm@linux-foundation.org
Subject: + bloat-o-meter-support-comparing-library-archives.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 18:50:10 -0700
Message-ID: <20200618015010.VTjwe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731255AbgFRBuM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nborisov@suse.com


The patch titled
     Subject: scripts/bloat-o-meter: Support comparing library archives
has been added to the -mm tree.  Its filename is
     bloat-o-meter-support-comparing-library-archives.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bloat-o-meter-support-comparing-library-archives.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bloat-o-meter-support-comparing-library-archives.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nikolay Borisov <nborisov@suse.com>
Subject: scripts/bloat-o-meter: Support comparing library archives

Library archives (.a) usually contain multiple object files so their
output of nm --size-sort contains lines like:

<ommitted for brevity>
00000000000003a8 t run_test

extent-map-tests.o:
<ommitted for brevity>

bloat-o-meter currently doesn't handle them which results in errors when
calling .split() on them.  Fix this by simply ignoring them.  This enables
diffing subsystems which generate built-in.a files.

Link: http://lkml.kernel.org/r/20200603103513.3712-1-nborisov@suse.com
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/bloat-o-meter~bloat-o-meter-support-comparing-library-archives
+++ a/scripts/bloat-o-meter
@@ -26,6 +26,8 @@ def getsizes(file, format):
     sym = {}
     with os.popen("nm --size-sort " + file) as f:
         for line in f:
+            if line.startswith("\n") or ":" in line:
+                continue
             size, type, name = line.split()
             if type in format:
                 # strip generated symbols
_

Patches currently in -mm which might be from nborisov@suse.com are

bloat-o-meter-support-comparing-library-archives.patch
