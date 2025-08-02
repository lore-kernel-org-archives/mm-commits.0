Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42641A5B86
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161334; cv=none; b=Le7MkQDPMX1C10jpWcqnqZrP/cojoTfXVvnDiLCZv10En3G6+2WH7tgF5YwR7LTdXTBdpyuRZUlym1Z42HOEBrGuHg5JQlNxXM2ejIQeoGoCkwxY9tsvdjoUIw8wVqqbvV+pUyA/ilwRGh+AN7XQZUkbtxfjc4ol/Lzsk5i4+RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161334; c=relaxed/simple;
	bh=YJtCZ/gcV0fQYz/NWXeZxQz0wpGMAke1oQT7dOuQhl4=;
	h=Date:To:From:Subject:Message-Id; b=jgxB+yyFKx7izdndWhsH4T5q0WxS3QAUzJ3J9NqTkBesISc0xXoPjr3AFxBO5WlDbimBVSBmFFtVkCBbyEY3qxB2TzEsx85OVltGIv/otET1skDd7rBmeTOheKH8urdMMW2AMyqMliTxcjHHT0mqj9XCv/rFHsEJRxCXDsWTzu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XoNWe+2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XoNWe+2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3358BC4CEEF;
	Sat,  2 Aug 2025 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161334;
	bh=YJtCZ/gcV0fQYz/NWXeZxQz0wpGMAke1oQT7dOuQhl4=;
	h=Date:To:From:Subject:From;
	b=XoNWe+2kV5BMdSiWbuxDE3+TvXTFYDA+GWAe+8ezSBfMSDZB7CFMQvJ6BVQzX+BD0
	 bm5pNAFxlqP32LsXH7RlGvBrF9hEfIYI/dgKtZfGm3rplZJIUjLxyEcOZlYCURtMen
	 +jZiY0yX/CSciPFVFieJC3iwzEmCnbbR625FbMT8=
Date: Sat, 02 Aug 2025 12:02:13 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,bp@alien8.de,anshuman.khandual@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-kconfig-restore-config_broken-help-text.patch removed from -mm tree
Message-Id: <20250802190214.3358BC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/Kconfig: restore CONFIG_BROKEN help text
has been removed from the -mm tree.  Its filename was
     init-kconfig-restore-config_broken-help-text.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init/Kconfig: restore CONFIG_BROKEN help text
Date: Mon Jul 14 05:20:02 PM PDT 2025

Linus added it in 2003, it later was removed.  Put it back.

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/init/Kconfig~init-kconfig-restore-config_broken-help-text
+++ a/init/Kconfig
@@ -169,6 +169,10 @@ menu "General setup"
 
 config BROKEN
 	bool
+	help
+	  This option allows you to choose whether you want to try to
+	  compile (and fix) old drivers that haven't been updated to
+	  new infrastructure.
 
 config BROKEN_ON_SMP
 	bool
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


