Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D8D3C457A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439138; cv=none; b=OtkCw0wV5Xr54yQ0qgN7T3T01u+Songp4NwM/nZqSFt7kRWChwXANO8lzoh6+P7IIUW5I2Gg2LMfmH7CzJuGowW7QHD9ynFnOJrO05AgTYyUdbWAkAS79egyKul0eHTUwZUyFlAVT+NGxP/VVmru5WX6zGtOfYIloM1VQgTDCvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439138; c=relaxed/simple;
	bh=bUDliuYu1s4Sn5CHT+VxcUwZTPBYGXCUI0xMUTBocnQ=;
	h=Date:To:From:Subject:Message-Id; b=azNfqnVSlKenvlWxdwSOh2RXPqFpvZQgD3ZolxY4N8D2PeUgIOqmkYH7LIZVe/s6Es1tpAsdFbOzY0eQ+YXjvcNRVm78wTtAq6g1uS5USCvDDQ8dSCWFiZbX8cro6VoRgKOMtTEpB8fsyOZdgsXJ013CIHIDXslfQv7Y9PbJExI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SpcF1HDL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SpcF1HDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC481F00893;
	Tue,  2 Jun 2026 22:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439137;
	bh=xIiIHQ0JvSmkSiEN/FCdv9idKwQ8q94lEhvLPLd4afQ=;
	h=Date:To:From:Subject;
	b=SpcF1HDLsYQA1szeAvy3eeUY4b7gn7xeYhlGPAucd3BLc5gDmHSOvwCR2pvtUCaJu
	 CVIGEmshQiC4+C+51loZcH5qndXzzL8pP1NGyLdIpPNiagb7UpTdCrBCHMU2Jhvgoj
	 u7LZJw7d98P76vV0EJ/fJFgaIxd95KpJ1gKm7pO4=
Date: Tue, 02 Jun 2026 15:25:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-more-files-to-page-cache-section.patch removed from -mm tree
Message-Id: <20260602222537.2AC481F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add more files to PAGE CACHE section
has been removed from the -mm tree.  Its filename was
     maintainers-add-more-files-to-page-cache-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: MAINTAINERS: add more files to PAGE CACHE section
Date: Wed, 20 May 2026 17:17:12 -0400

Add include/linux/writeback.h and
include/trace/events/{filemap.h,readahead.h,writeback.h}.

Link: https://lore.kernel.org/20260520-page-cache-maintainers-v1-1-f93438d2186d@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

--- a/MAINTAINERS~maintainers-add-more-files-to-page-cache-section
+++ a/MAINTAINERS
@@ -20174,6 +20174,10 @@ T:	git git://git.infradead.org/users/wil
 F:	Documentation/filesystems/locking.rst
 F:	Documentation/filesystems/vfs.rst
 F:	include/linux/pagemap.h
+F:	include/linux/writeback.h
+F:	include/trace/events/filemap.h
+F:	include/trace/events/readahead.h
+F:	include/trace/events/writeback.h
 F:	mm/filemap.c
 F:	mm/page-writeback.c
 F:	mm/readahead.c
_

Patches currently in -mm which might be from tz2294@columbia.edu are


