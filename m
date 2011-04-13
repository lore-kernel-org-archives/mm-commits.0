From: akpm@linux-foundation.org
Subject: + mm-thp-use-conventional-format-for-boolean-attributes.patch added to -mm tree
Date: Wed, 13 Apr 2011 12:19:29 -0700
Message-ID: <201104131919.p3DJJTNP027848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757408Ab1DMTVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Apr 2011 15:21:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mel@csn.ul.ie, riel@redhat.com, rientjes@google.com, stable@kernel.org


The patch titled
     mm/thp: use conventional format for boolean attributes
has been added to the -mm tree.  Its filename is
     mm-thp-use-conventional-format-for-boolean-attributes.patch

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
Subject: mm/thp: use conventional format for boolean attributes
From: Ben Hutchings <ben@decadent.org.uk>

The conventional format for boolean attributes in sysfs is numeric ("0" or
"1" followed by new-line).  Any boolean attribute can then be read and
written using a generic function.  Using the strings "yes [no]", "[yes]
no" (read), "yes" and "no" (write) will frustrate this.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org> 	[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-use-conventional-format-for-boolean-attributes mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-use-conventional-format-for-boolean-attributes
+++ a/mm/huge_memory.c
@@ -244,24 +244,25 @@ static ssize_t single_flag_show(struct k
 				struct kobj_attribute *attr, char *buf,
 				enum transparent_hugepage_flag flag)
 {
-	if (test_bit(flag, &transparent_hugepage_flags))
-		return sprintf(buf, "[yes] no\n");
-	else
-		return sprintf(buf, "yes [no]\n");
+	return sprintf(buf, "%d\n",
+		       test_bit(flag, &transparent_hugepage_flags));
 }
 static ssize_t single_flag_store(struct kobject *kobj,
 				 struct kobj_attribute *attr,
 				 const char *buf, size_t count,
 				 enum transparent_hugepage_flag flag)
 {
-	if (!memcmp("yes", buf,
-		    min(sizeof("yes")-1, count))) {
+	unsigned long value;
+	char *endp;
+
+	value = simple_strtoul(buf, &endp, 0);
+	if (endp == buf || value > 1)
+		return -EINVAL;
+
+	if (value)
 		set_bit(flag, &transparent_hugepage_flags);
-	} else if (!memcmp("no", buf,
-			   min(sizeof("no")-1, count))) {
+	else
 		clear_bit(flag, &transparent_hugepage_flags);
-	} else
-		return -EINVAL;
 
 	return count;
 }
_

Patches currently in -mm which might be from ben@decadent.org.uk are

origin.patch
linux-next.patch
mm-thp-use-conventional-format-for-boolean-attributes.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch

