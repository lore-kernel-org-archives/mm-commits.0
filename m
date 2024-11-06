Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC677DA9E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854863; cv=none; b=A35ot0MleQEjWcvpgo84iqCDZv0AkbPYTRbynmdi7gZ5uXCztE0jaZGfChzxDgcogaQ6qla2SlRakFjdgcjY66etDeiuw6TBB3bJwlXUvxAw8A6GynTcqP5RT7Vs45zLwbQ0Yzz/4x/zo+1hGBIgQAA5N9v9egSLOrlxMW157tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854863; c=relaxed/simple;
	bh=+LW79ShiOZBiKixyLz2hYJPqydTlQ4xjC1h0V/Bj7Jc=;
	h=Date:To:From:Subject:Message-Id; b=n/tW7lqEYKfQkf4IPzpZdnWybqZ2da6OUvmgRZWo+dSSVrcaJoijY+6jhfJq8Urz8jF3lIgsj0HqE//RTbd4AayLVj5A4bQUICT+Y8rjoo2XL0BE4QGzbfHjsUIk3qNB9drLhzBcB1rLSro1y+fWC6Tya8VT6yftWJC4kNH4Tbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fdhHLrsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fdhHLrsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F73C4CED2;
	Wed,  6 Nov 2024 01:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854863;
	bh=+LW79ShiOZBiKixyLz2hYJPqydTlQ4xjC1h0V/Bj7Jc=;
	h=Date:To:From:Subject:From;
	b=fdhHLrsVBy/g9yNkysBl6AH2IXbTQTpwde8IYGFQQ5WwV1F9OLCDr6JTmWpJfnUD7
	 PDDHQY/Yvv7aTjd6Vuedi+nIbBT/NVyouDE+Ph2H+pQHiTB9S+XtgjyOqyw847jvRu
	 7Bd6bPmUrEdMoBHzNxNx+AMddYSdrhupeW7x0lgQ=
Date: Tue, 05 Nov 2024 17:01:02 -0800
To: mm-commits@vger.kernel.org,liujing@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-free-the-allocated-memory.patch removed from -mm tree
Message-Id: <20241106010103.72F73C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm: free the allocated memory
has been removed from the -mm tree.  Its filename was
     tools-mm-free-the-allocated-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Jing <liujing@cmss.chinamobile.com>
Subject: tools/mm: free the allocated memory
Date: Tue, 22 Oct 2024 09:25:26 +0800

The comm_str memory needs to be freed if the search_pattern function call
fails in get_comm

[akpm@linux-foundation.org: fix whitespace]
Link: https://lkml.kernel.org/r/20241022012526.7597-1-liujing@cmss.chinamobile.com
Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/mm/page_owner_sort.c~tools-mm-free-the-allocated-memory
+++ a/tools/mm/page_owner_sort.c
@@ -377,6 +377,7 @@ static char *get_comm(char *buf)
 	if (errno != 0) {
 		if (debug_on)
 			fprintf(stderr, "wrong comm in follow buf:\n%s\n", buf);
+		free(comm_str);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from liujing@cmss.chinamobile.com are


