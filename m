Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7521CD15
	for <mm-commits@vger.kernel.org>; Wed, 26 Nov 2025 19:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185212; cv=none; b=psb1sbLZp6YRNmFd5mo3uYN8IhXZZV5YNxk//9+EftAAe8zR2lcfDCg5lchOGgmpmbbW8fVm1yYI++boh592n85UjBsb0GxTit0qdBndcN1bYBczHleAcYMVs/liXpxeEcHJtJUQs9UMjaQw6RWp9/Eua8XMmmFdG5w57CRy7nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185212; c=relaxed/simple;
	bh=40QAGtnJnN1hXR+l+oJINozbSzAkcONu8nVLn7ghpww=;
	h=Date:To:From:Subject:Message-Id; b=APw74Rf79lEPZIC4UO4n4z3+9+lr2wxVqKYxHYmNrc/Ga9olyKqJS5YyA0FnhYY34PX4B/YfghPwVxU9320USOsvHSlZbHfwB+hhWbRUZcua/Ll1ZbQzQP3/3qo2PpBF/oTkUd2rw+rgeY02nGqC7vC8x/bHhn+kuSvM2ia3T1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RCOlNEmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RCOlNEmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88F4C113D0;
	Wed, 26 Nov 2025 19:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764185211;
	bh=40QAGtnJnN1hXR+l+oJINozbSzAkcONu8nVLn7ghpww=;
	h=Date:To:From:Subject:From;
	b=RCOlNEmFE2JkL+7qMXItaKUu9qKLm5XfCEA40VwyNH+kuRQuE3oD+L5HmJ/LR0xlP
	 AAldD68tlD3DYF9U6jpPAXymHMYrHUSCyxDaWe9uwE5xlMnZoTA1hJ6FOJiuVJUwR2
	 tX9q4HOpG+HK9tiC88R/vBXAqSqLcc/r5RGv8wZ0=
Date: Wed, 26 Nov 2025 11:26:51 -0800
To: mm-commits@vger.kernel.org,dhowells@redhat.com,bboscaccy@linux.microsoft.com,James.Bottomley@HansenPartnership.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + oid_registry-allow-arbitrary-size-oids-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20251126192651.D88F4C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: oid_registry: allow arbitrary size OIDs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     oid_registry-allow-arbitrary-size-oids-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/oid_registry-allow-arbitrary-size-oids-v2.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: oid_registry: allow arbitrary size OIDs
Date: Wed, 26 Nov 2025 14:22:33 -0500

tidy up perl with better my placement also set bc to arbitrary size

Link: https://lkml.kernel.org/r/dbc90c344c691ed988640a28367ff895b5ef2604.camel@HansenPartnership.com
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/build_OID_registry |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/lib/build_OID_registry~oid_registry-allow-arbitrary-size-oids-v2
+++ a/lib/build_OID_registry
@@ -60,7 +60,7 @@ for (my $i = 0; $i <= $#names; $i++) {
     # Determine the encoded length of this OID
     my $size = $#components;
     for (my $loop = 2; $loop <= $#components; $loop++) {
-	$ENV{'BC_LINE_LENGTH'} = "200";
+	$ENV{'BC_LINE_LENGTH'} = "0";
 	my $c = `echo "ibase=10; obase=2; $components[$loop]" | bc`;
 	chomp($c);
 
@@ -103,7 +103,7 @@ for (my $i = 0; $i <= $#names; $i++) {
 
     for (my $loop = 2; $loop <= $#components; $loop++) {
 	# get the base 2 representation of the component
-	$ENV{'BC_LINE_LENGTH'} = "200";
+	$ENV{'BC_LINE_LENGTH'} = "0";
 	my $c = `echo "ibase=10; obase=2; $components[$loop]" | bc`;
 	chomp($c);
 
@@ -114,15 +114,12 @@ for (my $i = 0; $i <= $#names; $i++) {
 	$c = substr("0000000", 0, ($tmp + 1) * 7 - length($c)).$c;
 
 	# Base128 encode the number
-	my $j;
-	my $b;
-	for ($j = 0; $j < $tmp; $j++) {
-	    $b = oct("0b".substr($c, $j * 7, 7));
+	for (my $j = 0; $j < $tmp; $j++) {
+	    my $b = oct("0b".substr($c, $j * 7, 7));
 
 	    push @octets, $b | 0x80;
 	}
-	$b = oct("0b".substr($c, $j * 7, 7));
-	push @octets, $b;
+	push @octets, oct("0b".substr($c, $tmp * 7, 7));
     }
 
     push @encoded_oids, \@octets;
_

Patches currently in -mm which might be from James.Bottomley@HansenPartnership.com are

oid_registry-allow-arbitrary-size-oids.patch
oid_registry-allow-arbitrary-size-oids-v2.patch

