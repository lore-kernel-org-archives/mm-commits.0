From: akpm@linux-foundation.org
Subject: [patch 123/127] .gitattributes: set git diff driver for C source
 code files
Date: Fri, 07 Oct 2016 17:03:04 -0700
Message-ID: <57f837b8.+nAjPPx+9hDMeLnB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39703 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932593AbcJHADF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jdelvare@suse.de, corbet@lwn.net, joe@perches.com, peterz@infradead.org

From: Jean Delvare <jdelvare@suse.de>
Subject: .gitattributes: set git diff driver for C source code files

Git can be told to apply language-specific rules when generating diffs. 
Enable this for C source code files (*.c and *.h) so that function names
are printed right.  Specifically, doing so prevents "git diff" from
mistakenly considering unindented goto labels as function names.

Link: http://lkml.kernel.org/r/20160907143403.1449324f@endymion
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitattributes |    2 ++
 1 file changed, 2 insertions(+)

diff -puN /dev/null .gitattributes
--- /dev/null
+++ a/.gitattributes
@@ -0,0 +1,2 @@
+*.c   diff=cpp
+*.h   diff=cpp
_
