Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8A3433C9
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247701; cv=none; b=ZZBaAo+L7QXXtaiPVnUFNnh60iNWF7hsn/2JNRoytPIpf48k+lwpq09h1N7xGWBZc+w13i9L8FYBAUNted0rIVx0vuIgA+xFVa0QEOzJCFWB+PVl8Mo+G366yDGOazx1YJff1OR1WKELX4Xifx2UwE850Buh16zYICP05fllUaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247701; c=relaxed/simple;
	bh=47I8gkz/aqVO8oetSB4VLkB8KUj71MraOxZRNgMYJWI=;
	h=Date:To:From:Subject:Message-Id; b=sknlZlw63kpLOs4+3eCSLfVY+nyM3cXDGm8Az7wB0tgOL426U1ZhXSxQ0uk160g/gOduFLe4z69SNVtPKCCLxRwky/LGjz/yDRO0AsElfhnQehXRz2qlYcE3oyTega6MRUraUIDl0HrLO2dMZ998dGMFw/BxVWtagEAtdr2lUFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OOT5gR9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OOT5gR9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F389AC4CEC2;
	Mon,  2 Sep 2024 03:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247701;
	bh=47I8gkz/aqVO8oetSB4VLkB8KUj71MraOxZRNgMYJWI=;
	h=Date:To:From:Subject:From;
	b=OOT5gR9Ci7O6SaFBtVWRRTQ55ar9Gk42/Yzen/bJ7zrIuYzNkEK3cyRnV4zUCE+GH
	 OxwGTfGLV5KpRaQOg+LtuuKzh/6+LQsV/JFWHliQWHxOB9buIjJUIkfzK2kpu5sGvZ
	 CbxUEcpLCvIiLD4q+2ZCD13W0BxvzpzUA8Xs6kjw=
Date: Sun, 01 Sep 2024 20:28:20 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,david@redhat.com,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-use-min-to-improve-dmirror_exclusive.patch removed from -mm tree
Message-Id: <20240902032820.F389AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: test_hmm: use min() to improve dmirror_exclusive()
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-use-min-to-improve-dmirror_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: lib: test_hmm: use min() to improve dmirror_exclusive()
Date: Fri, 26 Jul 2024 15:12:46 +0200

Use min() to simplify the dmirror_exclusive() function and improve its
readability.

Link: https://lkml.kernel.org/r/20240726131245.161695-1-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-use-min-to-improve-dmirror_exclusive
+++ a/lib/test_hmm.c
@@ -799,10 +799,7 @@ static int dmirror_exclusive(struct dmir
 		unsigned long mapped = 0;
 		int i;
 
-		if (end < addr + (ARRAY_SIZE(pages) << PAGE_SHIFT))
-			next = end;
-		else
-			next = addr + (ARRAY_SIZE(pages) << PAGE_SHIFT);
+		next = min(end, addr + (ARRAY_SIZE(pages) << PAGE_SHIFT));
 
 		ret = make_device_exclusive_range(mm, addr, next, pages, NULL);
 		/*
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are

mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write.patch
lib-checksum-use-array_size-to-improve-assert_setup_correct.patch
ocfs2-use-max-to-improve-ocfs2_dlm_seq_show.patch

