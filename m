Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78611D4611
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802154; cv=none; b=uLa4oz8LjZL27I1JoxXbGr43kZ0opLVFAx+homgnmmnAA7b79jYWSMws7fQLUmO50eND+9d4tubFrjb47K45p9t0vXBghKBNXPEfgzsxNMZc8CRjc3FxUxk8Uy8KqNcWT2vfgisJmChAmhIPQq5K0Rodhhbz/4L3XRATdc8UwQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802154; c=relaxed/simple;
	bh=i3AnuNkjyKQXo0ThZNJQGddBUW3Ykd+yXQCkD8HBpGg=;
	h=Date:To:From:Subject:Message-Id; b=DQDrdPy4gc4Eng1r7QqjoX/A1NciyNo6Uk+DjfrPt0W/MLMT+R0e/5NJxZnaM0JgG68hjY3/4ihoxO0We0ltJ6TOCHUfCd8M4fmp4k7ez8kUwS+sH3DC5omqMwOy9efDUH/vLGpr0HlkwyIpv0WwuTkkRTmN1mL6kh1EKAeeIJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AkXbdQGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AkXbdQGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D447C32786;
	Tue, 27 Aug 2024 23:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724802154;
	bh=i3AnuNkjyKQXo0ThZNJQGddBUW3Ykd+yXQCkD8HBpGg=;
	h=Date:To:From:Subject:From;
	b=AkXbdQGPtLTNCc9D51Eq/ponHwN67bZuzkzE6Hj5H+0e3nHjkmEMYZ3YjHjnnKL8E
	 OBjmprZhW2VSe85mI+9YVsv2uHvqzWDKSP5lFBu7VShsEPdqKIc4353Z95v1/QdITe
	 36wDedQBhaKT/ztsLlsSWXke7tEUmzlJlD9YklSI=
Date: Tue, 27 Aug 2024 16:42:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,trondmy@kernel.org,kees@kernel.org,gregkh@linuxfoundation.org,anna@kernel.org,andy@kernel.org,lihongbo22@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-string_choices-add-str_true_false-str_false_true-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20240827234234.8D447C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/string_choices: add str_true_false()/str_false_true() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-string_choices-add-str_true_false-str_false_true-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-string_choices-add-str_true_false-str_false_true-helper.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hongbo Li <lihongbo22@huawei.com>
Subject: lib/string_choices: add str_true_false()/str_false_true() helper
Date: Tue, 27 Aug 2024 10:45:15 +0800

Add str_true_false()/str_false_true() helper to retur a "true" or "false"
string literal.  We found more than 10 cases currently exist in the tree. 
So these helpers can be used for these cases.


This patch (of 3):

Add str_true_false()/str_false_true() helper to return "true" or "false"
string literal.

Link: https://lkml.kernel.org/r/20240827024517.914100-1-lihongbo22@huawei.com
Link: https://lkml.kernel.org/r/20240827024517.914100-2-lihongbo22@huawei.com
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Trond Myklebust <trondmy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_choices.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/string_choices.h~lib-string_choices-add-str_true_false-str_false_true-helper
+++ a/include/linux/string_choices.h
@@ -42,6 +42,12 @@ static inline const char *str_yes_no(boo
 	return v ? "yes" : "no";
 }
 
+static inline const char *str_true_false(bool v)
+{
+	return v ? "true" : "false";
+}
+#define str_false_true(v)		str_true_false(!(v))
+
 /**
  * str_plural - Return the simple pluralization based on English counts
  * @num: Number used for deciding pluralization
_

Patches currently in -mm which might be from lihongbo22@huawei.com are

lib-string_choices-add-str_true_false-str_false_true-helper.patch
mm-make-use-of-str_true_false-helper.patch
nfs-make-use-of-str_false_true-helper.patch

