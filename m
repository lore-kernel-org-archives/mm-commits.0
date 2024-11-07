Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B18C216A32
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731016845; cv=none; b=pQnplzM4ICgPy3001wzq2w44QYtzqm8WKkWlwokcR0uWYs9+fHrvBFxUyQUQf1Elqr4s+rmSGGL1FrSIBJsgpdU52qmsb/cXrGc7z60JsXCxNWZMhpbbxADemRkLKDRndEMajJJIjvV/AOilFiMQoDVtiSobVEhgEgvattwyJJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731016845; c=relaxed/simple;
	bh=R/U+AtSXMuE2eb7LGWeGv++m/jOceYkktELmcaDm44g=;
	h=Date:To:From:Subject:Message-Id; b=ba6ONwcvFhOGWs5JapnZlBvCId5vkRnoBGwu2WRsybSly4lzF8ys3l9C03ByTscS7DagZU7jDi6EWgwlzW8/CaX2CnkaAvadb63Q80n1VQYau6FeKp8ctdD+Uge9bn3I2mOGiI7O0ys+b/d3IbHcw9hQ8QPwAPOth0NlnuNPzDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qCZK1/qI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qCZK1/qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73B9C4CECC;
	Thu,  7 Nov 2024 22:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731016844;
	bh=R/U+AtSXMuE2eb7LGWeGv++m/jOceYkktELmcaDm44g=;
	h=Date:To:From:Subject:From;
	b=qCZK1/qI2CjK/A8ez/Tp5xZzcuJCnM8tvrU+mKoJj84r1sSIvmPE6c2nai1aN0YdV
	 90LyOOPNSuLxxGJqB77zkbVv4o6l7+aV67F40eTKSsI+v2jv0etB63l9lRZWeZ9rGk
	 pOMnkzhWZaVV1b0QnYS8IgBotFZHkMlAjjJVONDQ=
Date: Thu, 07 Nov 2024 14:00:44 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,rostedt@goodmis.org,olteanv@gmail.com,mpe@ellerman.id.au,kuba@kernel.org,krzysztof.kozlowski@linaro.org,bhelgaas@google.com,bagasdotme@gmail.com,arnd@arndb.de,andrew@lunn.ch,f.fainelli@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-remove-self-from-dsa-entry.patch removed from -mm tree
Message-Id: <20241107220044.D73B9C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: remove Florian from DSA entry
has been removed from the -mm tree.  Its filename was
     maintainers-remove-self-from-dsa-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -16082,7 +16082,6 @@ F:	drivers/net/wireless/
 
 NETWORKING [DSA]
 M:	Andrew Lunn <andrew@lunn.ch>
-M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
_

Patches currently in -mm which might be from f.fainelli@gmail.com are


