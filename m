Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7281A2D1913
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671893; cv=none; b=Lh5QF/4F4N0DzEZg2pFONeATN0qE6ysPXDXAmZZqpn3I+JX91w5cp/cVQafKSUZD0JQMgJ1FER6ffvrlQk4u0yYCp0lGHP8BOY66RYUVO6GwCrTQ6PQOqxGkshj+SIkmR96Bvy1ZiZBckILT9txc1viekCryV+xBuiy4LtjktBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671893; c=relaxed/simple;
	bh=3Mabi9gDiCIdUInrkO2c/78DItsCh24dQEk2357QKv4=;
	h=Date:To:From:Subject:Message-Id; b=XnQhxpVTe0Wy3tdGkenHqcPXIFw3e/JjBsv0AP3Fk/K8z/szmlekg0D/aG1SE0MseLpn5sBeLP7X9YEBjKClgUD57ce4Q4Zvcu1aCLOxtVSDS8gESxpeOOZiixbg2CyCgxV7YBUTDIgT8l43L2bTKND6gPiV8QKcJJsENkESugg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DlPpwZUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DlPpwZUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E45C4CEF7;
	Sat, 28 Mar 2026 04:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671893;
	bh=3Mabi9gDiCIdUInrkO2c/78DItsCh24dQEk2357QKv4=;
	h=Date:To:From:Subject:From;
	b=DlPpwZUBKImCWlS7mzoeotl32zzn6U1mdUVIL9vBCYR41TRJtJ71Zexqxmkk+RmfO
	 CYIO8/kuAiaa/lUIJ9O6IGGsb1MfctcWY8xm6LNbP2mhLJKjMmRpfUhz3TdoxCNa/D
	 2aY2BD/QYOgHkhjIzGfsq5LZoT7qRBdiqSiiMdMw=
Date: Fri, 27 Mar 2026 21:24:52 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash_dump-remove-redundant-less-than-zero-check.patch removed from -mm tree
Message-Id: <20260328042453.49E45C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_dump: remove redundant less-than-zero check
has been removed from the -mm tree.  Its filename was
     crash_dump-remove-redundant-less-than-zero-check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: crash_dump: remove redundant less-than-zero check
Date: Sat, 28 Feb 2026 09:51:36 +0100

'key_count' is an 'unsigned int' and cannot be less than zero. Remove
the redundant condition.

Link: https://lkml.kernel.org/r/20260228085136.861971-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_dump_dm_crypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/crash_dump_dm_crypt.c~crash_dump-remove-redundant-less-than-zero-check
+++ a/kernel/crash_dump_dm_crypt.c
@@ -115,7 +115,7 @@ static int restore_dm_crypt_keys_to_thre
 
 	addr = dm_crypt_keys_addr;
 	dm_crypt_keys_read((char *)&key_count, sizeof(key_count), &addr);
-	if (key_count < 0 || key_count > KEY_NUM_MAX) {
+	if (key_count > KEY_NUM_MAX) {
 		kexec_dprintk("Failed to read the number of dm-crypt keys\n");
 		return -1;
 	}
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


