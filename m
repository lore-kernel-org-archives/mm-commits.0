Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA6417753
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 00:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730421667; cv=none; b=r6dAeA76tAaTnnJsCNdUYNblPNEBlMCykZG6gj8YDTF525odu+w8oPoUysIAi7hm3lle3om5JezvrxQiIC2vbd4q/3KnReaHEWSC+MoMHNDvZnc6/IzFc6bZqJmThLM97BZx72x6cbm3GSXwmaDXJ81m0L5jT7y4Zk/y7SuzY5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730421667; c=relaxed/simple;
	bh=awoUIXi0sGo+3yFaGb/ydER/iK7XIJGjK9p+FIBY2vU=;
	h=Date:To:From:Subject:Message-Id; b=cebEWXIVo0EYixvizPmit30y0M2H3bA6nQdrOVz58tlCt7lOG5YQ1Hga4LjjBhwHdzOEc8gmzRiTxiPjfQz2ESAgSzB939Nsjm1WLvDxXH/9BQ4Us+1rztxpOf2b+5X+lrD8sdXZIIv2HGDI4fnfXGdUQG78hbJlqdooO0edQik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HH4nXluq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HH4nXluq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE6DC4CEC3;
	Fri,  1 Nov 2024 00:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730421667;
	bh=awoUIXi0sGo+3yFaGb/ydER/iK7XIJGjK9p+FIBY2vU=;
	h=Date:To:From:Subject:From;
	b=HH4nXluqzmuoziGUgdyQzcwNavLRVhNIA9m6fuCWlKTlSHiJQ3DSKA56HPvtHiimL
	 R+8bAGexw1gpedZh9tEO7ZmUPKVo+SXrILQwejQMwuX5okR2XljIXzKhTseOKI1JPB
	 dbYjdwGfg2HshVi+bUTQ8bNcaCzPPe4crZp9NKWo=
Date: Thu, 31 Oct 2024 17:41:06 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,rostedt@goodmis.org,olteanv@gmail.com,mpe@ellerman.id.au,kuba@kernel.org,krzysztof.kozlowski@linaro.org,bhelgaas@google.com,bagasdotme@gmail.com,arnd@arndb.de,andrew@lunn.ch,f.fainelli@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-self-from-dsa-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101004107.4FE6DC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: remove Florian from DSA entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-self-from-dsa-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-self-from-dsa-entry.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: MAINTAINERS: remove Florian from DSA entry
Date: Thu, 31 Oct 2024 10:33:29 -0700

Link: https://lkml.kernel.org/r/20241031173332.3858162-1-f.fainelli@gmail.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Vladimir Oltean <olteanv@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/CREDITS~maintainers-remove-self-from-dsa-entry
+++ a/CREDITS
@@ -1204,6 +1204,10 @@ S: Dreisbachstrasse 24
 S: D-57250 Netphen
 S: Germany
 
+N: Florian Fainelli
+E: f.fainelli@gmail.com
+D: DSA
+
 N: Rik Faith
 E: faith@acm.org
 D: Future Domain TMC-16x0 SCSI driver (author)
--- a/MAINTAINERS~maintainers-remove-self-from-dsa-entry
+++ a/MAINTAINERS
@@ -16028,7 +16028,6 @@ F:	drivers/net/wireless/
 
 NETWORKING [DSA]
 M:	Andrew Lunn <andrew@lunn.ch>
-M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

maintainers-remove-self-from-dsa-entry.patch

