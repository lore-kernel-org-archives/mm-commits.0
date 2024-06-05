Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C360BBA38
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628885; cv=none; b=gIkAWSvUwYWvoWnhfpLeGjpd8oXb5C+PEBvJkcUN8kAiBBO0c184flW6jl7mjQjdH5IikMjY3nILhcExUm1XakAnCP5xSA9sHi75fT4J0W/lwNX+uTfWb0dFR4C4itvPf0lDwKHg16gG+LUWDIUoIZi1F6n/FKbKK96xLHsmD5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628885; c=relaxed/simple;
	bh=ELhJJrvvM39sAp98HuIoJouvw/hAr4yL79oLPPYIqYw=;
	h=Date:To:From:Subject:Message-Id; b=SQv+oH7qKGxxiFvqW6fabL1Or6rUndbpOCU16f9eXC9w2iFCssnVmLcMYsakg/HU20ctmMryRlaDAJu+MmM663Ezyssc80kavHBzUhKLy80+rVrMiQgrn49yR2xtTL2hZuc+gMjOyxjYu77WSYmX8ulUPGW39hajp4AQBMtjxKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uyGTc0v4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uyGTc0v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8095BC2BD11;
	Wed,  5 Jun 2024 23:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717628885;
	bh=ELhJJrvvM39sAp98HuIoJouvw/hAr4yL79oLPPYIqYw=;
	h=Date:To:From:Subject:From;
	b=uyGTc0v4U7ESNLFkWia3D14UuDLYVnk844fEphcHt46eH8ekBB7LKlcgjWEnPoq1n
	 5GhLvl+7R3VO5XJHkKwgBNgWESexbHzU1/escGZ2aReBwIg6OFq1j603sGHz3pyasS
	 Iq6rqUG2yi6hbxOREX6iOwJMg2PifytLLGNMpc2k=
Date: Wed, 05 Jun 2024 16:08:04 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,keescook@chromium.org,elver@google.com,andreyknvl@gmail.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ubsan-add-missing-module_description-macro.patch added to mm-unstable branch
Message-Id: <20240605230805.8095BC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ubsan: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-unstable branch.  Its filename is
     ubsan-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ubsan-add-missing-module_description-macro.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: ubsan: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 19:06:48 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_ubsan.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-test_ubsan-v1-1-c2a80d258842@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_ubsan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_ubsan.c~ubsan-add-missing-module_description-macro
+++ a/lib/test_ubsan.c
@@ -156,4 +156,5 @@ static void __exit test_ubsan_exit(void)
 module_exit(test_ubsan_exit);
 
 MODULE_AUTHOR("Jinbum Park <jinb.park7@gmail.com>");
+MODULE_DESCRIPTION("UBSAN unit test");
 MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
test_xarray-add-missing-module_description-macro.patch
ubsan-add-missing-module_description-macro.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch

