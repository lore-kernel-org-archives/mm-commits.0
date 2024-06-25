Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC51143862
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291648; cv=none; b=EYSDUwSh59cyjISBiXcDdZ161A2BfJTUrOJvfXyjeEk6xOod9PndsX7bXEPTe1b+pFJhJFnbRZMGIf8aaKaOV/pphJI4ANda8TmSpVSCQlRJyc5+Jsnhpio9KtfzqweW6Y2UBZPhZ5AuEeropeKdURdAGLG6gz0j7lS1LHn1NsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291648; c=relaxed/simple;
	bh=Xw2peygxTaiyrXzZrNfcx0GuDmAU7U2f2164/K5NBlU=;
	h=Date:To:From:Subject:Message-Id; b=b8UF3+jk0/xOVRnkBEfSA6xL4nem0OItTmjm6OGjaSLZWb7HtaOeGaO2jPe/01QSASOQU20p10A855UUZ8qf6sjxcpJ7kMgFLYrIjWq7FL4pxgKVW+QCodwPAImMy4OetkB8eDBsU/i02QggEGEAT1/4YRBfG8JJOYOrUiP9K9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NfzcoLgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NfzcoLgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20307C32789;
	Tue, 25 Jun 2024 05:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291648;
	bh=Xw2peygxTaiyrXzZrNfcx0GuDmAU7U2f2164/K5NBlU=;
	h=Date:To:From:Subject:From;
	b=NfzcoLgX8Z4S6tynaL/C6fCk1QfCsaP233D/OafqwVTxNSlrHGmZwHswZNZnGaeMC
	 lFZoLiXm+hYtTlRqAs5OIs7flE/JaSs/b8+zte2bx7gDqiEFSOObxKoqugtbXaplcd
	 dh2EO1JYx5xpBvb+DnhIVsAGTyLbrSay9tpDpcDQ=
Date: Mon, 24 Jun 2024 22:00:47 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240625050048.20307C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: test_hmm: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: lib: test_hmm: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 16:26:03 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_hmm.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-lib-md-test_hmm-v1-1-e4aa17daa57b@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_hmm.c~lib-test_hmm-add-missing-module_description-macro
+++ a/lib/test_hmm.c
@@ -1550,4 +1550,5 @@ static void __exit hmm_dmirror_exit(void
 
 module_init(hmm_dmirror_init);
 module_exit(hmm_dmirror_exit);
+MODULE_DESCRIPTION("HMM (Heterogeneous Memory Management) test module");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

backtracetest-add-module_description.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch
lib-test_linear_ranges-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-for-lib-test_ko.patch
kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

