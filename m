Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492A42DBF78
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280959; cv=none; b=hz0YyfhLErBSn0rsRCbm8etWH+Tkxfl4Md7MRbfvskwrVUgublfF+V2O3pleruG6N+iJnWONxNRWbWZ0Z2lRBTN3Rte9Ach2iBN8gPczK5T+X3YjOrsMCaaaM/7zCG/qSFzyfeadVVgZlECIj+OIrku3zw40RvKZdzJ7mNPBqHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280959; c=relaxed/simple;
	bh=D+0D4H1KPjaVltzYAjN6Hvq1CEqYYGLkMR11A8U44VA=;
	h=Date:To:From:Subject:Message-Id; b=tZEDNJKkmzSRywEi9XBDlZ7s3HYu0o8KsXnNrcSZxIJgtd8aRdML7OzFK+dn05Nn49nGa8JPlxHHIKJbzhZZw+gTko6NxMpYSmG9nmLFgCkveti6k4Hu80EOEqlur6UHXYoQtoO2+zUaLxKnoBp8xPrnJm+5PwrNT78PrxmWgsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rti4AsGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rti4AsGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25ABC116C6;
	Tue, 13 Jan 2026 05:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280958;
	bh=D+0D4H1KPjaVltzYAjN6Hvq1CEqYYGLkMR11A8U44VA=;
	h=Date:To:From:Subject:From;
	b=Rti4AsGYe1eJSuX5I7XBBlIFwuoS2ZKstLt/GNMxRRlmyTjvpDn9qEUmhnMxXHE/+
	 sKMHUWolTaQ7P9Ugn67oqqk1EYoUf5tfQ1lHg6VfnPaXsZR0jyC43Z2p0Jk7Ez8u3N
	 XHcgdIgkxQyejD34//M3GdEcfEc1Uzvmp632bfGQ=
Date: Mon, 12 Jan 2026 21:09:18 -0800
To: mm-commits@vger.kernel.org,tgraf@suug.ch,davem@davemloft.net,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] textsearch-describe-list-member-in-ts_ops-search.patch removed from -mm tree
Message-Id: <20260113050918.D25ABC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: textsearch: describe @list member in ts_ops search
has been removed from the -mm tree.  Its filename was
     textsearch-describe-list-member-in-ts_ops-search.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: textsearch: describe @list member in ts_ops search
Date: Fri, 19 Dec 2025 08:40:05 +0700

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/textsearch.h:49 struct member 'list' not described in 'ts_ops'

Describe @list member to fix it.

Link: https://lkml.kernel.org/r/20251219014006.16328-4-bagasdotme@gmail.com
Fixes: 2de4ff7bd658 ("[LIB]: Textsearch infrastructure.")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/textsearch.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/textsearch.h~textsearch-describe-list-member-in-ts_ops-search
+++ a/include/linux/textsearch.h
@@ -35,6 +35,7 @@ struct ts_state
  * @get_pattern: return head of pattern
  * @get_pattern_len: return length of pattern
  * @owner: module reference to algorithm
+ * @list: list to search
  */
 struct ts_ops
 {
_

Patches currently in -mm which might be from bagasdotme@gmail.com are


