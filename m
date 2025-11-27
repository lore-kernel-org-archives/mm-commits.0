Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38794311966
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 20:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764275761; cv=none; b=Ydue6aZmvhBAHKa3Xu5ZjqNbcn5cBKwmkrc8Hviej9Qu6xhB/k9Sd4/itiEtsz8kAjs7phP9jcwDwz4aS2Ql+Yyoo7q2xYSkovv6H3AXBIDQD3WPBD+W931w+gfbscJjDP4XtzEythO2jNV4J2et9huo+k0yJiWhjMM24DQ3ai0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764275761; c=relaxed/simple;
	bh=RFV12RqzpuegvGn8CEISPgcWPtB/t177v0lt7s4FrC8=;
	h=Date:To:From:Subject:Message-Id; b=B2Wq/aegjW0aJPvREYab+VrilMohGxSTYh0yw+UU6nApW8ab8+uUujgR7a8CnkApOCLdU1DnnWVt0YLfUGrMXnFlcFaWC+pPF0AE8F2amUhnnfBgm9xCCmbqqMTDYSQqq3IjbE5ZnVpDXM+lcPXTAkueYHi6Ciz58B7Phl0rFx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xl6gUiVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xl6gUiVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D69C4CEF8;
	Thu, 27 Nov 2025 20:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764275761;
	bh=RFV12RqzpuegvGn8CEISPgcWPtB/t177v0lt7s4FrC8=;
	h=Date:To:From:Subject:From;
	b=Xl6gUiVhOMThJHHVwmbVO0e6tm6ScC7x0WhhpOOA7MijBlHOGZdbPNqIq4G3b/R43
	 I2JIBAQmcIdtnd/SlCwRwIocE9gQYqSzSkWBezy6HaSgZjEuhOe3TWWcwLW+O1VOjF
	 InbBAkjBWCUiwZI5tjelBMCMYJ2I403s+vyyya6A=
Date: Thu, 27 Nov 2025 12:36:00 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kexec-print-out-debugging-message-if-required-for-kexec_load.patch removed from -mm tree
Message-Id: <20251127203600.F0D69C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: print out debugging message if required for kexec_load
has been removed from the -mm tree.  Its filename was
     kexec-print-out-debugging-message-if-required-for-kexec_load.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Qiang Ma <maqianga@uniontech.com>
Subject: kexec: print out debugging message if required for kexec_load
Date: Wed, 26 Nov 2025 16:44:27 +0800

commit a85ee18c7900 ("kexec_file: print out debugging message if
required") has added general code printing in kexec_file_load(), but not
in kexec_load().

As a result, when using '-d' for the kexec_load interface, print nothing
in the kernel space.

And print out type/start/head of kimage and flags to help debug.

Link: https://lkml.kernel.org/r/20251126084427.3222212-4-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510310332.6XrLe70K-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kexec.c~kexec-print-out-debugging-message-if-required-for-kexec_load
+++ a/kernel/kexec.c
@@ -166,6 +166,9 @@ static int do_kexec_load(unsigned long e
 	if (ret)
 		goto out;
 
+	kexec_dprintk("kexec_load: type:%u, start:0x%lx head:0x%lx flags:0x%lx\n",
+		      image->type, image->start, image->head, flags);
+
 	/* Install the new kernel and uninstall the old */
 	image = xchg(dest_image, image);
 
_

Patches currently in -mm which might be from maqianga@uniontech.com are


