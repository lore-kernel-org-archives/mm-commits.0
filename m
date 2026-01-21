Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB551236437
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966320; cv=none; b=KxLuXaH1m4HYoZPJQkRQdhYsNGkWsb7zWNypeKNfPQICVwNmKqlE719Bq96/b22KoBgfqlTJh0o0p9T/+zolJpMfVwwMEagriw5rfznjLjT8ueQZygtWLDzt93cTYed3oAHJuSEYVY64mXO84WDupdsm56Cotsir5oDgVLQsuRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966320; c=relaxed/simple;
	bh=VwU6fTVijlCswh8cKyMQhT21llboI/DyBQzgmukuKeg=;
	h=Date:To:From:Subject:Message-Id; b=lqypnfqy3HXb0yObjy9maso6C5Lcx5aR1Ht9n1hyvV8gffg/JB7bAHOd5nW+IqoeaLL7ULZA6AMFPspcDj7ebd2I6N20ZmCrvIm/7ZSLd9QoOYZen3dGa7kaDfdxa1wYl7vSQs/lQJ56gHjc23Mzt1BVoORZmEGn+z3IKLMZjZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Aw7eZpQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Aw7eZpQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11210C16AAE;
	Wed, 21 Jan 2026 03:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966319;
	bh=VwU6fTVijlCswh8cKyMQhT21llboI/DyBQzgmukuKeg=;
	h=Date:To:From:Subject:From;
	b=Aw7eZpQn3hDqRR05UzNwZx46pumL3tKJzOrE7i9TA441g1KIRJ98p3h/1Tp8wtG2Y
	 weGuMD7ugw/xiDi/wkXfngOyKAwWeEzm+xU2ClAcrkt4hiUgCnpU9TmYOf88XAfGfF
	 fwzFoDgShg3jJGymn9xeQLNCEubgSWACZlKXJW9s=
Date: Tue, 20 Jan 2026 19:31:58 -0800
To: mm-commits@vger.kernel.org,dhowells@redhat.com,bboscaccy@linux.microsoft.com,James.Bottomley@HansenPartnership.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] oid_registry-allow-arbitrary-size-oids-v2.patch removed from -mm tree
Message-Id: <20260121033159.11210C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: oid_registry: allow arbitrary size OIDs
has been removed from the -mm tree.  Its filename was
     oid_registry-allow-arbitrary-size-oids-v2.patch

This patch was dropped because it was folded into oid_registry-allow-arbitrary-size-oids.patch

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

