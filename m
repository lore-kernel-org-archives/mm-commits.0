Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D094B378D6B
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 09:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518396; cv=none; b=Pt1zUV7zItCqL63I2wY039ismGOcJzQvjvCEsae1NB2f5zRDXP331L3nEaoCTQyOBzvsnmz08Ky0KtTRrRreaHCdf+btBm4e7tpyTNy6waesUeADVPsWsu3q0hqqO1t7Fip9NjqLlAm/yVe9FrG8VxfCx8SB9lY9ezUXCDi89nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518396; c=relaxed/simple;
	bh=RYcW4guaouQ+9vEdodbDaIujw77A+YX+xQapnsv5GtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ccFs0du2iPw6D7fbFeC373NnwciV3EyV8banuL9iubVP3mX4/EtwHre1XSQ8kUiM8zfu/TRyimTf84QJI7J43hQZqJjE8rtpjBz0DAD0r4dndoYBmDXbX26m8WbxQgeRO1JAbkb3r28xW0/PZuUWKdbqiwwrxH9ygx8rk7Sglvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=me1IsGEw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="me1IsGEw"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PI6oCk3137323;
	Thu, 26 Mar 2026 09:46:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:sender:subject:to; s=pp1;
	 bh=Qn/+De1O7s2JQ4N35cCrjMHcfWyAtFssea02zNl5z30=; b=me1IsGEwbejO
	uKn1OD+pVowX1J5CEzUQE5frJPK05N0/4akfr7U4pFkhys2eD0RL2TVoCFMrkUSB
	luRNKS678C9FOqPB52ITPlrP0n6vMACnEri2uz93eu8clvUIxpgW2OM6zANTQn8A
	EtXepzKUueYW6iXGVCA7q68dKCwPY6denOQyrDFKn/cTYSs6pBsOozQM9MaQeass
	IgQjWz+VXgxGnB5BbU39M16wl54c4gTJR/4baHc9tCta2bS/z0FevoRbYXidyE9x
	/XALvEc9oXc9yKCip266Z4BhHxalxzd4YQHfbjEODWe+Q5g6hGv5axVBHgusT0r+
	HugZTz6R3g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kwa4j6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 09:46:29 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62Q74Vx1009126;
	Thu, 26 Mar 2026 09:46:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nntcj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 09:46:28 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62Q9kQBa44696038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Mar 2026 09:46:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 950ED20043;
	Thu, 26 Mar 2026 09:46:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 845C020040;
	Thu, 26 Mar 2026 09:46:26 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.52.223.163])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 26 Mar 2026 09:46:26 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.99.1)
	(envelope-from <bblock@linux.ibm.com>)
	id 1w5hII-0000000G2ma-11Bt;
	Thu, 26 Mar 2026 10:46:26 +0100
Date: Thu, 26 Mar 2026 10:46:26 +0100
From: Benjamin Block <bblock@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@kernel.org>, mm-commits@vger.kernel.org
Subject: Re: +
 debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch
 added to mm-nonmm-unstable branch
Message-ID: <20260326094626.GC252856@p1gen4-pw042f0m>
References: <20260311174822.42D6DC4CEF7@smtp.kernel.org>
 <87qzp7et8k.ffs@tglx>
 <20260325115527.36034bfd3d91d6f258526c74@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260325115527.36034bfd3d91d6f258526c74@linux-foundation.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C9h_NgQ17JLKlZI1M2_hN0ojUG-bDt3h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2NyBTYWx0ZWRfX0jzkymjosPHb
 W5qP+BzoQF0xXa8Gm6qMSWneAd09QMz3oHi0OCinoGVJ4ZBWs8lVEx2YGvFVegNBWkMLDf3gkk2
 yBmXme0iVdyg7OtdQnCPqFXtIgBuq9M1e9LvUetCECjWBCxQYg/OxL0vv8po7pYHlNFPxBJYC3P
 CZic8yP5KDMo9KTU7cKgBxsfOHyiTfDv+UcdKrNQKMLta7T1jIktUipXAnrhxkF0j0u3ME2HfzB
 zTm5ai3hIGfm4SAv5lU+ywwLgbDA/+FZPTtFFC8ZdwKnq6T87F6GUQKEruCVf4OiGgGBqTjuExm
 A+z3y7gd3EZrWf7y9Mq8thxBvULz7GRh36BIK2NKqUDN/tjj1WeoxZwt6dH+I69C1IOIPvFPRjJ
 AZggzubK+WfeuN4pnYCOzNbzDUoHho2GQjuWLxzU+0awMVZ0AG+CpYg/eAb4Ulk/d+c0aAn1F+Z
 IWpntSpC7VdBKOBC26w==
X-Proofpoint-GUID: C9h_NgQ17JLKlZI1M2_hN0ojUG-bDt3h
X-Authority-Analysis: v=2.4 cv=OsZCCi/t c=1 sm=1 tr=0 ts=69c50075 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=8nJEP1OIZ-IA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=8amUqTf9allW9fEIYMcA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1011 phishscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603260067

On Wed, Mar 25, 2026 at 11:55:27AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 18:03:55 +0100 Thomas Gleixner <tglx@kernel.org> wrote:
> 
> > Andrew!
> > 
> > On Wed, Mar 11 2026 at 10:48, Andrew Morton wrote:
> > > The patch titled
> > >      Subject: debugobjects: allow to configure the amount of pre-allocated objects
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > >      debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch
> > 
> > Can you please drop this. The underlying problem is not explained at
> > all and the question I asked vs. deferred page init is not answered.
> > 
> 
> Yep, no probs, I agree that this isn't the one.
> 
> Benjamin, please do pursue this - the issue is real and has been around
> for a long time!

I'll get back to you both; I was out for a couple of days :)

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Ehningen     /     Registergericht: AmtsG Stuttgart, HRB 243294
