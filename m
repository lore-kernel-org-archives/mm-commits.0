From: akpm@linux-foundation.org
Subject: + mm-mempolicy-silence-gcc-warning.patch added to -mm tree
Date: Wed, 20 Nov 2013 14:15:45 -0800
Message-ID: <528d3491.X5FBuAA4bEYkWh2r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab3KTWPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:15:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org, fengguang.wu@intel.com, rientjes@google.com

Subject: + mm-mempolicy-silence-gcc-warning.patch added to -mm tree
To: rientjes@google.com,fengguang.wu@intel.com,keescook@chromium.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:15:45 -0800


The patch titled
     Subject: mm, mempolicy: silence gcc warning
has been added to the -mm tree.  Its filename is
     mm-mempolicy-silence-gcc-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-silence-gcc-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-silence-gcc-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-mempolicy-silence-gcc-warning.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch

