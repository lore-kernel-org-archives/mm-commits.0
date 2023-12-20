Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBB3E547;
	Wed, 20 Dec 2023 02:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="BbBb+ARD"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BK2DZBu003473;
	Wed, 20 Dec 2023 02:52:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=Lu8QLKD3BJTpy8KehDX+u4mswZLOmdQldksIflIVy0I=; b=Bb
	Bb+ARDXCfE2a2Js4aD1mhYzTmA/D+TCMRdbeIOXANVo7g7o+/BVlSNDbrQ1J/stE
	1CEmrwkVBf3RvUpzjgLOoPABhdGi5UMfprMe+21t8tpIJZalBSm9ItOEeCau3oDo
	49tE4xHWj/6dTqHfxn0uDRlDc+EjFHPEwuqcNpTCCKNTciXbKp6ldikeRwmWchlt
	klp6GxipcolrfLX7mmaeI5M4795AFkCLhfM+FwyA7cy3aPJ53KlQf4/rpX2o04Du
	kAUxuGWID7rHaryUxJAskPJcoF7wE2az6MbC86xy49j3cJAqAETv9Rj31DvRRtmh
	A+qAJZyay4SVEuWQZbcA==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3v35x7jq9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 02:52:53 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3BK2qqwF001449
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 02:52:52 GMT
Received: from [10.216.23.215] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Tue, 19 Dec
 2023 18:52:49 -0800
Message-ID: <ab0fa643-8c6b-d7b7-6d21-066e27469b9e@quicinc.com>
Date: Wed, 20 Dec 2023 08:22:46 +0530
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: + mm-migrate-high-order-folios-in-swap-cache-correctly.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
        <willy@infradead.org>, <stable@vger.kernel.org>, <shakeelb@google.com>,
        <n-horiguchi@ah.jp.nec.com>, <kirill.shutemov@linux.intel.com>,
        <hannes@cmpxchg.org>, <david@redhat.com>
References: <20231214221150.7EC0DC433C9@smtp.kernel.org>
Content-Language: en-US
From: Charan Teja Kalla <quic_charante@quicinc.com>
In-Reply-To: <20231214221150.7EC0DC433C9@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 3zMrtp3iG33xerWCGxZAj3rwfkHy2gG7
X-Proofpoint-ORIG-GUID: 3zMrtp3iG33xerWCGxZAj3rwfkHy2gG7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_01,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=847
 lowpriorityscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312200017

Hi Andrew,

On 12/15/2023 3:41 AM, Andrew Morton wrote:
> Large folios occupy N consecutive entries in the swap cache instead of
> using multi-index entries like the page cache.  However, if a large folio
> is re-added to the LRU list, it can be migrated.  The migration code was
> not aware of the difference between the swap cache and the page cache and
> assumed that a single xas_store() would be sufficient.
> 
> This leaves potentially many stale pointers to the now-migrated folio in
> the swap cache, which can lead to almost arbitrary data corruption in the
> future.  This can also manifest as infinite loops with the RCU read lock
> held.
> 
> [willy@infradead.org: modifications to the changelog & tweaked the fix]
> Fixes: 3417013e0d183be ("mm/migrate: Add folio_migrate_mapping()")
> Link: https://lkml.kernel.org/r/20231214045841.961776-1-willy@infradead.org
> Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reported-by: Charan Teja Kalla <quic_charante@quicinc.com>
>   Closes: https://lkml.kernel.org/r/1700569840-17327-1-git-send-email-quic_charante@quicinc.com
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Errors were reported from checkpatch.pl.

1) Seems we have used 15chars of sha1.
2) space before Closes:

Summary:

WARNING:BAD_FIXES_TAG: Please use correct Fixes: style 'Fixes: <12 chars
of sha1> ("<title line>")' - ie: 'Fixes: 3417013e0d18 ("mm/migrate: Add
folio_migrate_mapping()")'
#21:
--
WARNING:BAD_REPORTED_BY_LINK: Reported-by: should be immediately
followed by Closes: with a URL to the report
#26:
