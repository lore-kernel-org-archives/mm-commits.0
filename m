From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicy-silence-gcc-warning.patch removed from -mm
 tree
Date: Fri, 22 Nov 2013 13:21:59 -0800
Message-ID: <528fcaf7.RCrRsQr2W+b1weba%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3KVVWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:22:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org, fengguang.wu@intel.com, rientjes@google.com

Subject: [merged] mm-mempolicy-silence-gcc-warning.patch removed from -mm tree
To: rientjes@google.com,fengguang.wu@intel.com,keescook@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:21:59 -0800


The patch titled
     Subject: mm, mempolicy: silence gcc warning
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-silence-gcc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempolicy: silence gcc warning

Fengguang Wu reports that compiling mm/mempolicy.c results in a warning:

	mm/mempolicy.c: In function 'mpol_to_str':
	mm/mempolicy.c:2878:2: error: format not a string literal and no format arguments

Kees says this is because he is using -Wformat-security.

Silence the warning.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicy-silence-gcc-warning mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-silence-gcc-warning
+++ a/mm/mempolicy.c
@@ -2950,7 +2950,7 @@ void mpol_to_str(char *buffer, int maxle
 		return;
 	}
 
-	p += snprintf(p, maxlen, policy_modes[mode]);
+	p += snprintf(p, maxlen, "%s", policy_modes[mode]);
 
 	if (flags & MPOL_MODE_FLAGS) {
 		p += snprintf(p, buffer + maxlen - p, "=");
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch

