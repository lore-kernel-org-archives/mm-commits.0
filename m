Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF1A214A89
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188441; cv=none; b=cbahQ+SuxsrZQ9493HOJEp4JsUYmAEH9NV4NmjUTXT3aK+rwt1p3nqbDNhremFEb65Sk5PvMW0Vh6HvalQi9f5TWMNnj4zK04Y1hc9gxrBiY1d0Ral0Y1JWVlFv5Yf0V3+NYuRh8syuA5sWvbtQJHRuN2toXxdBAbHaVMJqa7bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188441; c=relaxed/simple;
	bh=Qj4UCAldZxL1jDVKNwnI6JOWp8kCtRUE0TMgplUpxWY=;
	h=Date:To:From:Subject:Message-Id; b=pZjgez1mxceu3GklC9zcaDH5c79n7pIREx18s/HAD3Dy+BOq4Z9L1Wkp+IWtCxCFVqgqiZ96c13Dc8qR9WLxuPG0jPsjb9iTuqQCv35JQkEBUK6zlQOyrufPZf8k7zq6Cb5+D2dpa31SOjLCePpcHd74+oNFDBwb0oVuRWbXr2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BeIxpi/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BeIxpi/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742B3C4CEEC;
	Mon, 17 Mar 2025 05:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188441;
	bh=Qj4UCAldZxL1jDVKNwnI6JOWp8kCtRUE0TMgplUpxWY=;
	h=Date:To:From:Subject:From;
	b=BeIxpi/Xrve/E/kS66vbE8phsWFuItMsAEAsFWZePReFrlnddei8tUogwXR7Gc3o7
	 2cSHQZr8T/FdvPk1xslEoJmy0oSqSV03lFufMbx0QWr6gHMjLrtLM13QNY4PQ8VJaX
	 khvhzN2NZA80n0NoAc+HwHat73Q6Nvn1zb3CyyTE=
Date: Sun, 16 Mar 2025 22:14:00 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch removed from -mm tree
Message-Id: <20250317051401.742B3C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: print some details when uffd-stress gets bad params
has been removed from the -mm tree.  Its filename was
     selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: print some details when uffd-stress gets bad params
Date: Tue, 11 Mar 2025 13:18:16 +0000

So this can be debugged more easily.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-5-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-print-some-details-when-uffd-stress-gets-bad-params
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -457,7 +457,8 @@ int main(int argc, char **argv)
 
 	nr_pages_per_cpu = bytes / page_size / nr_parallel;
 	if (!nr_pages_per_cpu) {
-		_err("invalid MiB");
+		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
+			bytes, page_size, nr_parallel);
 		usage();
 	}
 
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

