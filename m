Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F44B64A
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 03:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740454083; cv=none; b=I4zpng+sj6kU1gkKDKPGLR8dNjtiawupnoHz72OW4UlwfJuEnVIVfaThnbyAmZZVDp5yCV+zdwAm9SSGlZtVnlCNF8vvWhN2jwPkgoHqTDu79Q8gnKwrTY+YfgDmY4yPajbeBntbOog5bHH6I6d3LZe44Fa6HOUmKkGnSsIDJv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740454083; c=relaxed/simple;
	bh=Ui3LqUovzKxOEvEHfBdZvVk3Yqb+uoqVuHVF+5393do=;
	h=Date:To:From:Subject:Message-Id; b=jLD7knl2bvaO2L/SJBDHJpCvXzALxg3Ea/Q2PuTnTKbmlhR2nIBBtUuTYXpiyCriDUf7OfqW1iDS2B9M4rGDBgxSaFJPoNsiu2i1WUNXUZP3QPhK0t5O58gK3PDAZZorsvYSZAmwOzevT4FQE6Pbzw0DIvww1MkONQRJYBJWx/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P8YLidfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P8YLidfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1159C4CEE2;
	Tue, 25 Feb 2025 03:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740454082;
	bh=Ui3LqUovzKxOEvEHfBdZvVk3Yqb+uoqVuHVF+5393do=;
	h=Date:To:From:Subject:From;
	b=P8YLidfwT46uCJnS1PMl1/sQ8wCwY4UV1bwqNLWbiDxP+yKKx4iO70mRKbEzAnCDT
	 4nmBcTs6wDhvAY3InUpSJxcZC0Ft5vyhHbdwgvGekUIfI8cUyxvCQI01h/M+xRD/pR
	 Cy5NHne0NXmCZSo/UwNZNoyk6dOMgnoxddIOKzAE=
Date: Mon, 24 Feb 2025 19:28:02 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-drop-myself-from-reviewers.patch added to mm-unstable branch
Message-Id: <20250225032802.D1159C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: drop Christoph from Reviewers
has been added to the -mm mm-unstable branch.  Its filename is
     vmalloc-drop-myself-from-reviewers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-drop-myself-from-reviewers.patch

This patch will later appear in the mm-unstable branch at
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
From: Christoph Hellwig <hch@lst.de>
Subject: vmalloc: drop Christoph from Reviewers
Date: Mon, 24 Feb 2025 08:30:33 -0800

I haven't been doing as much review as I should.  As part of reducing my
inbox flow drop me from the official Reviewers.  I might still chime in on
patches occasionally.

Link: https://lkml.kernel.org/r/20250224163033.350072-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~vmalloc-drop-myself-from-reviewers
+++ a/MAINTAINERS
@@ -25286,7 +25286,6 @@ F:	tools/testing/vsock/
 VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
-R:	Christoph Hellwig <hch@infradead.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from hch@lst.de are

vmalloc-drop-myself-from-reviewers.patch

