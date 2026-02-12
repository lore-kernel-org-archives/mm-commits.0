Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BC3F9D9
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 20:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770928458; cv=none; b=NGnMZfXiAhMEUYn945/Y2Kv1pX6Aza8xvWI4e+lMTC3PX3InLWsfxuK2krj+Xhh10kUxs9FEtwfN5bcx/eaIYwZdotJDiHQoTpFI/GkmUnjTMzKLqKO7KMp3nWhJVYTIyki936lQsEDMWZ1j4ZhJrJWtWWCFvggd6pvRvvq0egc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770928458; c=relaxed/simple;
	bh=UgAi9iHJywZkElaer9UGgRTmFpmWo+UAB1gGy/q+/gQ=;
	h=Date:To:From:Subject:Message-Id; b=rIp01PoFcamc4Pfauqh2mPPb/Ph5DVHBYV753HYQpbwg6V7X99hHwENqD0QcTDNmZpzClTLke20hoZlM6QkrTxBlFIq/yr3JS5pMM0MRMT6vQ3wLvvo+l8A9WmXX1eAoTGm0RrvQ9JtmundMOTS48o+hp2ZUO31BuYEQfWI8pfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SrZaCSQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SrZaCSQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FAFC4CEF7;
	Thu, 12 Feb 2026 20:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770928458;
	bh=UgAi9iHJywZkElaer9UGgRTmFpmWo+UAB1gGy/q+/gQ=;
	h=Date:To:From:Subject:From;
	b=SrZaCSQEG1JhoFIEKo4Z80X9ZEvWtO4r32eloHbiyGqq9csvXdPuwvCHvJgswjMaw
	 xOBBh0Yf5kSw4RB8WK+k1xqU6mppSw80zUVOa2MnGRaK/21/l+CytNNUiqVux3Jrbj
	 bSbGjkJKcFCbuBvvAfaMqpJT+9ysVXWS9F9y1R2U=
Date: Thu, 12 Feb 2026 12:34:17 -0800
To: mm-commits@vger.kernel.org,liam.howlett@oracle.com,andrewjballance@gmail.com,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-update-mas_next-docs.patch removed from -mm tree
Message-Id: <20260212203417.F1FAFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: update mas_next[_range] docs
has been removed from the -mm tree.  Its filename was
     maple_tree-update-mas_next-docs.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Alice Ryhl <aliceryhl@google.com>
Subject: maple_tree: update mas_next[_range] docs
Date: Sun, 18 Jan 2026 11:00:41 +0000

If you read the docs, it sounds like the difference between these
functions is whether mas->index and mas->last are updated.  However, if
you read the implementation, you will instead find that the difference is
whether NULL entries are skipped.

Link: https://lkml.kernel.org/r/20260118-mas-next-doc-v1-1-827d9f4924ce@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-update-mas_next-docs
+++ a/lib/maple_tree.c
@@ -5060,13 +5060,14 @@ static bool mas_next_setup(struct ma_sta
 }
 
 /**
- * mas_next() - Get the next entry.
+ * mas_next() - Advance the maple state to the next range, skipping zero entries.
  * @mas: The maple state
  * @max: The maximum index to check.
  *
  * Returns the next entry after @mas->index.
+ * Updates @mas->index and @mas->last to the range.
  * Must hold rcu_read_lock or the write lock.
- * Can return the zero entry.
+ * Skips entries reserved with XA_ZERO_ENTRY.
  *
  * Return: The next entry or %NULL
  */
@@ -5083,11 +5084,12 @@ void *mas_next(struct ma_state *mas, uns
 EXPORT_SYMBOL_GPL(mas_next);
 
 /**
- * mas_next_range() - Advance the maple state to the next range
+ * mas_next_range() - Advance the maple state to the next range.
  * @mas: The maple state
  * @max: The maximum index to check.
  *
- * Sets @mas->index and @mas->last to the range.
+ * Returns the next entry after @mas->index.
+ * Updates @mas->index and @mas->last to the range.
  * Must hold rcu_read_lock or the write lock.
  * Can return the zero entry.
  *
_

Patches currently in -mm which might be from aliceryhl@google.com are


