Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17AF357734
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967084; cv=none; b=BT25Knt1NjhC1PpbdbbYimFHZEyrRbShyhZz7soAlm22NGdMfe6nIeDLT2uqO8kxeXcElVzB/GE7zNw2AQdaqIZAD0VkZ5hD3xJRbj2kNKHDpuO5AMh4l38jXlYKG/zvt4ARkmKWQj/JWzcC29kfZ5yom6G5Rj4uMDMfMtEucxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967084; c=relaxed/simple;
	bh=SQOl9SbONFT9BFW9+lq4Por2fpvG7ZCUayvPDVUCRdY=;
	h=Date:To:From:Subject:Message-Id; b=Bhj4w2qBDfduLc8iHWIJ6OlTApfFg3DeZAIZvnjsQQi3qanPqNI6qCr9vE5p+82crXI4qeeINv5ZeXMuhv9bvHdt1Yx4THgWHCYrlohdUjm1bADxfVSoWEXvdnqaHuJwKNxW+cbBcj935t5jZW3oD092Y1gCETQ8ciTedXKg7Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=crrQTGhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="crrQTGhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6E7C16AAE;
	Wed, 21 Jan 2026 03:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967084;
	bh=SQOl9SbONFT9BFW9+lq4Por2fpvG7ZCUayvPDVUCRdY=;
	h=Date:To:From:Subject:From;
	b=crrQTGhhy+0DHAzOjAP/sddI7TMDxQK7DqNB5aUYDjCgnkTO4U1i1cxDQ2dzJlgGR
	 FBYdtMimYpFIY2HgcTc9/ZBLbHNwCw25eVIPB9tg2GYPaFg+ZjkHugfFevZ7HixuAa
	 XFmNbSjHimS/W5CsssXGcQVfKYHZcwAAOYIRtZj0=
Date: Tue, 20 Jan 2026 19:44:43 -0800
To: mm-commits@vger.kernel.org,dhowells@redhat.com,bboscaccy@linux.microsoft.com,James.Bottomley@HansenPartnership.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] oid_registry-allow-arbitrary-size-oids.patch removed from -mm tree
Message-Id: <20260121034444.2E6E7C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: oid_registry: allow arbitrary size OIDs
has been removed from the -mm tree.  Its filename was
     oid_registry-allow-arbitrary-size-oids.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: oid_registry: allow arbitrary size OIDs
Date: Tue, 25 Nov 2025 13:19:56 -0500

The current OID registry parser uses 64 bit arithmetic which limits us to
supporting 64 bit or smaller OIDs.  This isn't usually a problem except
that it prevents us from representing the 2.25.  prefix OIDs which are the
OID representation of UUIDs and have a 128 bit number following the
prefix.  Rather than import not often used perl arithmetic modules,
replace the current perl 64 bit arithmetic with a callout to bc, which is
arbitrary precision, for decimal to base 2 conversion, then do pure string
operations on the base 2 number.

[James.Bottomley@HansenPartnership.com: tidy up perl with better my placement also set bc to arbitrary size]
  Link: https://lkml.kernel.org/r/dbc90c344c691ed988640a28367ff895b5ef2604.camel@HansenPartnership.com
Link: https://lkml.kernel.org/r/833c858cd74533203b43180208734b84f1137af0.camel@HansenPartnership.com
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/build_OID_registry |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/lib/build_OID_registry~oid_registry-allow-arbitrary-size-oids
+++ a/lib/build_OID_registry
@@ -60,10 +60,12 @@ for (my $i = 0; $i <= $#names; $i++) {
     # Determine the encoded length of this OID
     my $size = $#components;
     for (my $loop = 2; $loop <= $#components; $loop++) {
-	my $c = $components[$loop];
+	$ENV{'BC_LINE_LENGTH'} = "0";
+	my $c = `echo "ibase=10; obase=2; $components[$loop]" | bc`;
+	chomp($c);
 
 	# We will base128 encode the number
-	my $tmp = ($c == 0) ? 0 : int(log($c)/log(2));
+	my $tmp = length($c) - 1;
 	$tmp = int($tmp / 7);
 	$size += $tmp;
     }
@@ -100,16 +102,24 @@ for (my $i = 0; $i <= $#names; $i++) {
     push @octets, $components[0] * 40 + $components[1];
 
     for (my $loop = 2; $loop <= $#components; $loop++) {
-	my $c = $components[$loop];
+	# get the base 2 representation of the component
+	$ENV{'BC_LINE_LENGTH'} = "0";
+	my $c = `echo "ibase=10; obase=2; $components[$loop]" | bc`;
+	chomp($c);
 
-	# Base128 encode the number
-	my $tmp = ($c == 0) ? 0 : int(log($c)/log(2));
+	my $tmp = length($c) - 1;
 	$tmp = int($tmp / 7);
 
-	for (; $tmp > 0; $tmp--) {
-	    push @octets, (($c >> $tmp * 7) & 0x7f) | 0x80;
+	# zero pad upto length multiple of 7
+	$c = substr("0000000", 0, ($tmp + 1) * 7 - length($c)).$c;
+
+	# Base128 encode the number
+	for (my $j = 0; $j < $tmp; $j++) {
+	    my $b = oct("0b".substr($c, $j * 7, 7));
+
+	    push @octets, $b | 0x80;
 	}
-	push @octets, $c & 0x7f;
+	push @octets, oct("0b".substr($c, $tmp * 7, 7));
     }
 
     push @encoded_oids, \@octets;
_

Patches currently in -mm which might be from James.Bottomley@HansenPartnership.com are


