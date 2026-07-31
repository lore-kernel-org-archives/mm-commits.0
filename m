Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C10E33939E
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465835; cv=none; b=ggQyujeCJidvzp1rQBDcHQQE+gEWLp4fqqltUwMvq1PejGOI9RQgbyUOr7Xyx4i3owqC9gKKWsnqMWQG1cLuHspMp7dzB6BNdqeZzADNsNWx4nSWVzHFI+fajdaqfG+th/cv5SpgW6nnkxI9O1ib+hn7C856h+zRuoZatKA5ANo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465835; c=relaxed/simple;
	bh=qWdHSltBaJvD2y9YoyJ1x/apeovNPLjIbYGoigOT8LE=;
	h=Date:To:From:Subject:Message-Id; b=dBAL4i455L9TJg5Q8sjV0yvzWgg8zPhp5opgm19zp6SXhnZresZrt+4EvtXATwkLY6eYTc/7WSxnTrniO3frCa8hRz0zsgjxrQQlFTjCULByQCdk2WOuMNQaSk1Cy+iLo0wQgKwYoFrIerG3mJN4bTuKJOYWcGJR+/kMNCsA+RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HT95EtF+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HT95EtF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D5D1F00A3D;
	Fri, 31 Jul 2026 02:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465834;
	bh=pzrpj6LBJbYgZ9umi3R7+SV/f3osk4fFTtCUJoohMpk=;
	h=Date:To:From:Subject;
	b=HT95EtF++T/9jr3hz1c+3NliWU13Juu9Ov9I1FAURmAVYkRS2uEEzSiBTsT0kTl8f
	 XLOMWMNwR3IjsGDlqAhjelhBzfsF+IS6R4ewvod6dW7/tNsuQuHwqqMGICuvIPL3v6
	 GHOHE9W3WkDIjf+owlgiR7HBMuIXRKh66sHJYwZ0=
Date: Thu, 30 Jul 2026 19:43:53 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,senozhatsky@chromium.org,minchan@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-abi-docs-and-selftests-to-zram-entry.patch removed from -mm tree
Message-Id: <20260731024354.00D5D1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add ABI docs and selftests to ZRAM entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-abi-docs-and-selftests-to-zram-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: MAINTAINERS: add ABI docs and selftests to ZRAM entry
Date: Thu, 2 Jul 2026 16:56:55 +0800

Ensure updates to these files get sent to the right place.

Link: https://lore.kernel.org/20260702085655.51858-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Acked-by: SJ Park <sj@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-abi-docs-and-selftests-to-zram-entry
+++ a/MAINTAINERS
@@ -29787,8 +29787,11 @@ M:	Minchan Kim <minchan@kernel.org>
 M:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-block-zram
+F:	Documentation/ABI/testing/sysfs-class-zram
 F:	Documentation/admin-guide/blockdev/zram.rst
 F:	drivers/block/zram/
+F:	tools/testing/selftests/zram/
 
 ZS DECSTATION Z85C30 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@orcam.me.uk>
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

docs-mm-physical-memory-remove-deferred_split_queue.patch

