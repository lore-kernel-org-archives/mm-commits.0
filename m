Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF5318C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628632; cv=none; b=X/U+mlYEsMytwKxMLz9XoKpTSZvLaZwu3Dv4gmHS/3RzmRyLZTNaNd+kASF3/t0kT8FZkvHm6R44oqYp35moAeXqv1qzz6haobUWgdkhnKlISiK3prnrgI4/yrOkF+LbEU6UIKiUthCvI2NgQFbe37BERoR7tEkRlI4ThoYt/Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628632; c=relaxed/simple;
	bh=tcTJPHBXuOUqegL2suMn3pnZrXqNVhG23frGAPb3e4g=;
	h=Date:To:From:Subject:Message-Id; b=KsemC2SlaX9b7fzKapc9f3gOXNMyqdjCY0sgQt8Wv/L9T0m7F0BxOh4qRZZj9XKKxoSmtCNnI47i8phH2HK9SCwXElc2Vs6nSoCsfGa2hMJQtljLOi3BBrMDG17hQtIJTszPHZuobGN8gvptFaeensQmy4V/fb8/SHPPkMF7RlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VAzCcPi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VAzCcPi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44121C116B1;
	Sat, 29 Jun 2024 02:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628632;
	bh=tcTJPHBXuOUqegL2suMn3pnZrXqNVhG23frGAPb3e4g=;
	h=Date:To:From:Subject:From;
	b=VAzCcPi9NZUg/N+U32f053pWHD6Gyx+W9u8cOqz0L//xkSvdquszuXGU/5sf5nVnR
	 lKdoCCmxlb6KJpe6GnPhmIwqablCKTb2MERfjtF8HKg+QyNlTbQfR68iVhHvMg1nrF
	 /mhBuwU8RdoUuGQM7QK3ME3fRq3ZfaGRhoTnJyGI=
Date: Fri, 28 Jun 2024 19:37:11 -0700
To: mm-commits@vger.kernel.org,rafael.j.wysocki@intel.com,gregkh@linuxfoundation.org,andriy.shevchenko@linux.intel.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-add-missing-module_description.patch removed from -mm tree
Message-Id: <20240629023712.44121C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: add missing MODULE_DESCRIPTION()
has been removed from the -mm tree.  Its filename was
     resource-add-missing-module_description.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: resource: add missing MODULE_DESCRIPTION()
Date: Wed, 29 May 2024 16:31:58 -0700

Fix the 'make W=1' warning:
WARNING: modpost: missing MODULE_DESCRIPTION() in kernel/resource_kunit.o

Link: https://lkml.kernel.org/r/20240529-md-kernel-resource_kunit-v1-1-bb719784b714@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/resource_kunit.c~resource-add-missing-module_description
+++ a/kernel/resource_kunit.c
@@ -149,4 +149,5 @@ static struct kunit_suite resource_test_
 };
 kunit_test_suite(resource_test_suite);
 
+MODULE_DESCRIPTION("I/O Port & Memory Resource manager unit tests");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are


