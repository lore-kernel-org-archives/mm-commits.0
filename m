Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B4F143889
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248848; cv=none; b=FarI6fC1ZtYwE4dC3yoSERvdxgLXqni/PgH2MwhhXtZ0XEdSwo5sGDovm5t14RTJtQg1BBqicEQiIpFQ76VEqBGhiq044f2AtZVvjE0IOndRPr5VXW6T1t1cY8lcSU+fz0/BRI8V4APJzvxv80j2ZUNnBJo/1KAXfiXABQgI6rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248848; c=relaxed/simple;
	bh=UJalMk7mZAEvPf+Lasqr5UbesRddkLM6pIuyLikY2Cg=;
	h=Date:To:From:Subject:Message-Id; b=K0jrCg4RR1i0GGO4DDGYbNHeXw/1pVmRB3e2NukB+w4NGTFaG+6APYjOp3cHSzZWj1ZWFO0NMXNeqdAsll7QfEZmF6OxD74oSh5YXgLVkpyQyQiyuOKZlyuti7eGvPz2yzrLwTZwljwcTv+97KiS01XiT1WzO5izvKPqkHwadAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kyxde5lZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kyxde5lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AE2C4CEC2;
	Mon,  2 Sep 2024 03:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248848;
	bh=UJalMk7mZAEvPf+Lasqr5UbesRddkLM6pIuyLikY2Cg=;
	h=Date:To:From:Subject:From;
	b=kyxde5lZ3HTFjZGHlYYQXh2V2U7n5U0tEvj41m9VXU32+WdSflWq5QGSOPAFKQI50
	 DmlNgORD5eClJQVnUrAjbuleasRWfCpvAlTs4kFbSpG99WqpD/+Zj9TVduQ/2CrSli
	 Vd0aBDAtp2jtfe8+pwF0H0w+/H/XpmjPEGCqT/WI=
Date: Sun, 01 Sep 2024 20:47:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,trondmy@kernel.org,kees@kernel.org,gregkh@linuxfoundation.org,anna@kernel.org,andy@kernel.org,lihongbo22@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-string_choices-add-str_true_false-str_false_true-helper.patch removed from -mm tree
Message-Id: <20240902034728.36AE2C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/string_choices: add str_true_false()/str_false_true() helper
has been removed from the -mm tree.  Its filename was
     lib-string_choices-add-str_true_false-str_false_true-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-make-use-of-the-helper-macro-list_head.patch

