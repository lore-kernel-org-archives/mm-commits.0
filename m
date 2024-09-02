Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FBD13AA3F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248759; cv=none; b=n0pDCTixt5XwgTzbT1QhrAcKT0WRxBOTMV8Jr81MzlE2ZvoSf7xHjKy8rZeEvsuq6IVt8BlD0c/hp2rEpLkob6QIwh86Tj/N47LFRRqfzRH+Y6dLTCl9J1KwwHLIgepOSzkhy+jRwegEDOe+dZGcHpEaqg3e6zndRu09+iW4AEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248759; c=relaxed/simple;
	bh=sjVnnu0ZgC8WkvOxCJGpU3Zqnjvod1MXcCPejmvKzDk=;
	h=Date:To:From:Subject:Message-Id; b=AX/2IqmorrcGIvWdmWfkqP3cAhU430CYt0RyNSiCeUofTi7QOPtJnmIc3OAici9M/HQXAZ9gG7uOSDCXwzOue/elYo4mOq3Xk60kMGIscxPTZaTzrl2ALZp4o4k2hy7EBkRU8xi4DHqeJ83RQyLcfnlkxUbwKAGUUtZBrXO/1Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CXgZRrri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CXgZRrri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B9AC4CEC2;
	Mon,  2 Sep 2024 03:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248759;
	bh=sjVnnu0ZgC8WkvOxCJGpU3Zqnjvod1MXcCPejmvKzDk=;
	h=Date:To:From:Subject:From;
	b=CXgZRrriI0FyXUzq4n6/SB6oCfmOvJOyrJfOWnO30kUtxp9TFG2UY6n7jEM/XJ2xi
	 mnza47o+Rj/mkvDosJ9tcH03+6oSA/i7kWikUnoxiWkiYGFOmQst9iLzlfU6RaP86y
	 //OcGZP4J9AlLj96oiPSGh55n4Mva7LKQ/fHoF/s=
Date: Sun, 01 Sep 2024 20:45:58 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] licenses-add-0bsd-license-text.patch removed from -mm tree
Message-Id: <20240902034559.22B9AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: LICENSES: add 0BSD license text
has been removed from the -mm tree.  Its filename was
     licenses-add-0bsd-license-text.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: LICENSES: add 0BSD license text
Date: Sun, 21 Jul 2024 16:36:17 +0300

The license text was copied from:

    https://spdx.org/licenses/0BSD.html

Link: https://lkml.kernel.org/r/20240721133633.47721-3-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Jules Maselbas <jmaselbas@zdiv.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rui Li <me@lirui.org>
Cc: Simon Glass <sjg@chromium.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 LICENSES/deprecated/0BSD |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/LICENSES/deprecated/0BSD a/LICENSES/deprecated/0BSD
new file mode 100664
--- /dev/null
+++ a/LICENSES/deprecated/0BSD
@@ -0,0 +1,23 @@
+Valid-License-Identifier: 0BSD
+SPDX-URL: https://spdx.org/licenses/0BSD.html
+Usage-Guide:
+  To use the BSD Zero Clause License put the following SPDX tag/value
+  pair into a comment according to the placement guidelines in the
+  licensing rules documentation:
+    SPDX-License-Identifier: 0BSD
+License-Text:
+
+BSD Zero Clause License
+
+Copyright (c) <year> <copyright holders>
+
+Permission to use, copy, modify, and/or distribute this software for any
+purpose with or without fee is hereby granted.
+
+THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are


