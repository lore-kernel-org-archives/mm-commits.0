Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480EC13E02E
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313163; cv=none; b=k12MIVSbWRdVG6BLoW47sJ9tNPD9Cp6/wxWr/+oPJQvvESp/M1huwG8nSbWR2Nmq4KYL9/sibiJvO4Mb9PnIFWjrJVL0CcI4UJcbsVi1zirCEh7VrRKGuoUlNor+WUGam8LLnSgQ8SA8A9Zhp+Ra6Pr8tGDoRwxp0j11oP5GX6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313163; c=relaxed/simple;
	bh=WQVPwiH7HDTSRQZ91DIsoQ51C3Z79O1jZj7N1QE7FWY=;
	h=Date:To:From:Subject:Message-Id; b=YgEXCwuqp2t2OT8k/X+FuMrvicJhX+aafiCOoo6cpcQUsVJOssn0TKBpXzErp0KQNWzl+FL4VYYrPIJ6C8+6r6unONh5rM2Qa6pEgl6tKp3phLIrbsFCfzV2SJcLwGG1rCbPobzynfNhtR73E1rXWvnOqnmsvw/vnIOEVnoWjL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iOw2q9xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iOw2q9xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC538C4CED0;
	Mon, 11 Nov 2024 08:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313162;
	bh=WQVPwiH7HDTSRQZ91DIsoQ51C3Z79O1jZj7N1QE7FWY=;
	h=Date:To:From:Subject:From;
	b=iOw2q9xjoDaRnPROmSeVrzs22vb/wHnDJsoLIV3mVoYG4F8OySUPgmpjFFMn7F9qM
	 fYvtHHodJzsP1RpzuU17xcIZUNMBt0o5WCw4BPZQ8uiWzfalSllx2F8svzUU2Du5hN
	 09m6EeHznhaA5rfPWhWQ3sjLwwpq9QvG/M9CRwCY=
Date: Mon, 11 Nov 2024 00:19:22 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-migrate-copy_user_test-to-kunit-fix.patch removed from -mm tree
Message-Id: <20241111081922.BC538C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: export copy_to_kernel_nofault
has been removed from the -mm tree.  Its filename was
     kasan-migrate-copy_user_test-to-kunit-fix.patch

This patch was dropped because it was folded into kasan-migrate-copy_user_test-to-kunit.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: export copy_to_kernel_nofault
Date: Fri, 18 Oct 2024 15:11:09 +0000

This symbol is now used on the kasan test module, so it needs to be
exported.

ERROR: modpost: "copy_to_kernel_nofault" [mm/kasan/kasan_test.ko] undefined!

Link: https://lkml.kernel.org/r/20241018151112.3533820-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/maccess.c~kasan-migrate-copy_user_test-to-kunit-fix
+++ a/mm/maccess.c
@@ -82,6 +82,7 @@ Efault:
 	pagefault_enable();
 	return -EFAULT;
 }
+EXPORT_SYMBOL_GPL(copy_to_kernel_nofault);
 
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-migrate-copy_user_test-to-kunit.patch

