Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E376C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 16 Mar 2021 16:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A19165111
	for <mm-commits@archiver.kernel.org>; Tue, 16 Mar 2021 16:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhCPQ5q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Mar 2021 12:57:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60546 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbhCPQ5T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Mar 2021 12:57:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGdoUf162507;
        Tue, 16 Mar 2021 16:54:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DaBr9jFCwVPgIOj3sNRLo+1apmgD0NlGrvnrhN3TRqw=;
 b=b6J5NAQZgYWqGtrH3kRhm4Z0Ax/XWcn2UBEO4jm/fsz7wr1meAmoGYI7guKn4J6M/J9I
 ++/lM0H/U28HJQJtvSiolXLohap2htH6MiM6txeHo9957E46Zl8BAu1AVcZ+aNpSo+gs
 TmPfCEqnJfq4at8GVAd+YhqtfR/Gq90DiBTrRjVR5oroi/Zoxynze0TCBi0xgVQEwFoO
 zwjeaEncwLX0qGTp0wqe2zf1TeTuY8J+p0lLx4xyln+HgERS+sqTrRnoBbf5sWW5ZzG7
 sor0xzyurVd1YiTHTOnlvL3zUZ30taMgyHfSElTpKPn54lGnQM4iXHe9dU+CvC8mXmqk 9w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 378p1nrxth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:54:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGftW1036562;
        Tue, 16 Mar 2021 16:54:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3020.oracle.com with ESMTP id 37a4et6rbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:54:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkEDCo76LV9fULUBUD+BebIdx4xBNbk0MyhHTQfV38PR4uKWQfZ6jxhmXrG93hG575+0Cy08KrgFvnPnMz8nz0dDqHBgi2Yy9anWYQugVsiZkibSH62sZAxbT2vksKSVdm+atjJ+Doeok8ZnI/tzpHq7BegoCDd2X29ThjQwSyXJzAdLWU4CZoohFNhZtxOiCAtaEKsdlv270fig2nv0ZGqPBMAVPNZOWYOwZsiCpRFmYoejXVIdK+VH5RcnJvUYEw280R5HW6cYlJXSdkG36exrwzXsOHLxUycxg5gqCRjdS6CuDGzBHvblmf7RU2MIkuiygr9NMnAo6pxFm+Q4xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaBr9jFCwVPgIOj3sNRLo+1apmgD0NlGrvnrhN3TRqw=;
 b=jS4yqRGSitF78ycqDQh7LRR56MG/ho86FUgqRQIE1OF2gIZ9sLdXDogcJo1EAEKWZbWQDDUZvS0+O11E3NMvL2/9AWKmasf2VPVeXXOpml05W57X0k3zbxTKJ6UTPiO1geeymmMH4qSzjXln6sO2fkJ4e7UKpJ2PzZNgVvU4He6GcODr46CITevv1xrFW9fD0KQW/llVGz0xal2djj/b0l5aAvospuMYqiedxVfjCeJEsYmeq7o59mPTZ4+bGJQcPGvyMBZ4A42ZNuqLIiNd7jweo+nmH46fqrnsiJ3G6g1xQ02wbsJpbGWg1PytwRCq2jKEwovsCcDq+LhpGwtrbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaBr9jFCwVPgIOj3sNRLo+1apmgD0NlGrvnrhN3TRqw=;
 b=IcMYwfuVM2zh802JYCg9lo13Cb2c5PU1eudSNYEGUjguMsm6JNPp4DWwOLK4ezr7W/ozolcZHw75qvqaITPpbLGHmxohX+Sm54CsfEF+p1mFnkztETG4MFKSa6DMXsf2Mcx0Mc55gdwvl0Cs7IxNJpjezMiIPdWDhsOk7cOnHvo=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4573.namprd10.prod.outlook.com (2603:10b6:a03:2ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 16:54:53 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::980e:61ba:57d2:47ee]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::980e:61ba:57d2:47ee%8]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 16:54:53 +0000
Subject: Re: +
 mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
 added to -mm tree
To:     Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org
Cc:     almasrymina@google.com, anshuman.khandual@arm.com,
        bodeddub@amazon.com, bp@alien8.de, bsingharora@gmail.com,
        chenhuang5@huawei.com, corbet@lwn.net, dave.hansen@linux.intel.com,
        david@redhat.com, hpa@zytor.com, joao.m.martins@oracle.com,
        jroedel@suse.de, linmiaohe@huawei.com, luto@kernel.org,
        mchehab+huawei@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        oneukum@suse.com, osalvador@suse.de, paulmck@kernel.org,
        pawan.kumar.gupta@linux.intel.com, peterz@infradead.org,
        rdunlap@infradead.org, rientjes@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, willy@infradead.org
References: <20210315204819.8xAywsXO5%akpm@linux-foundation.org>
 <YFCHbGtshunwQxyc@dhcp22.suse.cz>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <f9901048-4ee1-85af-82f4-e3c2c71309bc@oracle.com>
Date:   Tue, 16 Mar 2021 09:54:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <YFCHbGtshunwQxyc@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:300:16::23) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR13CA0013.namprd13.prod.outlook.com (2603:10b6:300:16::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend Transport; Tue, 16 Mar 2021 16:54:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22443d49-782e-4485-fd3b-08d8e89c3854
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45737F339131320E2A2D6B4BE26B9@SJ0PR10MB4573.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJZ74WQvQrahrAJc3IaLINl8icP9NpVhMWs6oJvUkMRVMzmpzSp2QHB7S3WjcWzpKsaIDUwbce+yqPtbyCwQRTEu8t/LDBxpl19ee4RkW9mX3WR2s0JVxzFbMJw1UdZtfQq7kdzYDd6e53sunmDtdBZXlYj4R3Awg/iXQNmqCOFdUKovW4G0wGDIft0cJibep2RTqT8AVXEHOWu+yGZ13hs2dtXGFbsHcUDqldrrnsFUrqXKUYDeosaD10ezFJkJJjYfI+B81OeTvKP9T6nvt5ZliT+cXuYlVc4o1hwbXnncXhK9xKvGJ50AGTQ12p9HhhFQRAjXNP3j70zsmRZwidYrqZn9E/eZiTHolMZ3lP/mHqsg7MvrCvb0iL07zsZS9fmpm3EWUVT7q0cgkMiePDsQU2nbpCqNQgQh77OXdlUe/YeB3Q1WvVJEDcnNcZV/Mh5rPXFiI7GaLfQRXs0Yvxbpce4boz3PB6XrIy+LKCsvbCr97kGZh1fr/4kCST7GWakJ2x4/Po1JLZJwWqdM0YxF316+fKK+Mh/Fi3FkRb4hbrSB7QeqZBnBW2lRBi2XxAAYJBnYn6SvbcPUsseVKPjrmW2V7IVPgmF6WyIJS+TO/uZyRmYrNZCIGKQP4NyRO0oVcQqp4KRHtheBv36FqHXKUhOhXjJGN3PoHsyRU0Pv+G5VoD7oMGab6CPY9O46O/X/ReJb1SI3HcSEnJ3d1gawKrBZAWQI7jzM9mXdv7U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39840400004)(366004)(396003)(136003)(346002)(66946007)(186003)(66556008)(83380400001)(66476007)(52116002)(31686004)(478600001)(4326008)(5660300002)(966005)(86362001)(8676002)(31696002)(44832011)(36756003)(2906002)(7416002)(316002)(2616005)(8936002)(6486002)(53546011)(956004)(16526019)(16576012)(26005)(4744005)(7406005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bkwxdlIvemhkblpvZFZRd3hJY0lzczhDNm5rUUNmZzF2YjlOYkZxSWxDMmxQ?=
 =?utf-8?B?RkxUTVp6c1Vac3BNVVo0N3RFV2VLOGRETU1UZHordXZiKzdmQno3bytkMURr?=
 =?utf-8?B?ODJTMUVWcmZLQkVyT2p5bnVWaUU1T0NrbHpVL2JGeFpsTE1pRS9qNGkvUTBh?=
 =?utf-8?B?RWl3UEpYeUhEa0c3a2pjbnYrRTI0UlpiaU45MjRhUEJJWHJONWdwanErOWsv?=
 =?utf-8?B?MDMrektLOUVZUURJc2xJeEdwSFQrUlNkVmkyUDFVZU85Z3krNlNOTmJZYkt5?=
 =?utf-8?B?ckNmNlp4ekxvN21ralI3WHp0OHBvY2pyZEhFOURXZlRlNFVHZjhNM0wrYXM0?=
 =?utf-8?B?dWpDM3BpL2RMbFkxb0IzTWNsdFIvM1g0cnhndHRsYXFtcTNsSFVzMXlJeWVI?=
 =?utf-8?B?QUlGNitvY0tvNllMQWpJekFBUVBrbWlMZVZVdm0rK0hqM0VNYzJONzY0TFlF?=
 =?utf-8?B?OFEzNnB3YzdqTXhyZmZHc2gxMllsRi96enZjMlRzOEcyREhXd1VXUVpyVm1U?=
 =?utf-8?B?OUVrdGFyZjJhd2JheDJlNmhHVUtZeFpmK0RsWTJxTUJNNjFUWUNhOWxQQ2Rl?=
 =?utf-8?B?NlNNSkxzQ3VwRkVzc0o3ZDM3RHRqWng3eE0zU2ZLdWVDTGR0WlBGVk1tazRL?=
 =?utf-8?B?Yi9iQVFvRDM1cFpiNmxKUXJxV2ZxWlczZ2RaOTQ2MGJzVHFRUWtvSW9rQlhB?=
 =?utf-8?B?NTZPbjZRcFJhZmEwWS9CV0d4QXZONWt4SWtzN3FaUjQwWVQrQmlrRFo5OXRN?=
 =?utf-8?B?TWhpZllwUXlZQkdBQmRzV1BxaHlQcGFrbW9RSEIrRHBOa0VQcXFQL1pmSW84?=
 =?utf-8?B?V1hFR0pVUkRKUDMyVWQzSnBGUk9wMXhyQ2dUMnpGTTZQTUZGOFdOSmJSWG5z?=
 =?utf-8?B?MWpiVFM5dXMvbHRIT1NNbk9lbVlGYWxPWHJ0S21IQVg2QXE2bEtoNHVaeitB?=
 =?utf-8?B?T0plWG5PWEdweVRqN2xPeEcxcGJ5bE9yN1pHTHVkdnhJL1hmQzBac0dUaU1v?=
 =?utf-8?B?Q2d3QW8vdXVnaVduSHJsRUJZRjY2d2hlNnVYNkliaVRjZjRDMldSN2pFYXdW?=
 =?utf-8?B?blAxdEprSE5LNXp6MW1PTUU2TUZGRC9OQWMydDRadk1oVXh4Q2gwWEdRL3dx?=
 =?utf-8?B?eFdoSXpkcnVrUUtLOWhsK1h2UDF3TitvazVCdmNUTlJFNldsc05yTENKT3R1?=
 =?utf-8?B?TUg2OTFyNFJWMjZETjVWcmdmRkdsNjE5eVJZYjZYSEk3d1Y2dkg3eEVUVDJN?=
 =?utf-8?B?UkJEL3Jxd2pTQ1FqZ3ZDTm5LbC9zT3BidmZUL1l2OTRZeDEwL1puV0lPODBJ?=
 =?utf-8?B?WWh6cXRYTkg0MHh0WG1hOUxHQWpzOVVYUFpZem9LY0t0Q3F2M1hKUGxpc0pQ?=
 =?utf-8?B?TlppRzhBb0pzeTU0eWh1N1hCTmNrZkJTMFZVT1FvNFFscno0c1NubjhHQlJP?=
 =?utf-8?B?d21IM2tnZzNiZWV4YUdOSmRDc04rVUZZRHkrQndYUnBGVW9wYm5aVTJRZE90?=
 =?utf-8?B?WHZzZ0xBbFIzUmRJaUxPSCtUTGFOTTJ1cGlRazBhL3VzekVhSFdMSkJKUUVl?=
 =?utf-8?B?cGhMeXo2L2RjQjcvNVA1MVlJazVwbnBOaUNxc2h2bm8wdGRSK3QrRk4wMEU5?=
 =?utf-8?B?eWlMNjMvajlRV21Uc1ZGYmlXYjJYZGRRWmlhZE94WjRwUE1KZTBLMG5tbkhU?=
 =?utf-8?B?b3NnL25TbG9wVDRvQzdoazFSN0wzdUUxYUxQVHJVdUo1Yy9ndXFCaFdCWW10?=
 =?utf-8?Q?ApvHGnS7UrmqX07kqqY6diTArQXZSyzP90Wcj3e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22443d49-782e-4485-fd3b-08d8e89c3854
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 16:54:53.3050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y5LN7xBY/TV1ZQ+Vq40Xd5PGR7N8KM7x3OpssQqTxRA9P3Yv+esUr+O+EQhkfoKq0N+ys4vIxgd/fEq30cwrsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4573
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160108
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160108
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 3/16/21 3:24 AM, Michal Hocko wrote:
> Andrew,
> this patchset is still not ready for mmotm. Hugetlb freeing path needs a
> major surgery because it can be called from atomic contexts and a simple
> fix http://lkml.kernel.org/r/20210311021321.127500-1-mike.kravetz@oracle.com
> has been nacked by Peter. Until this is handled properly this has to
> wait and build on top.
> 

Unfortunately, I tend to agree.

Technically, this patchset does not add anything 'new' WRT challenges
with the put_page path.  It will add a new condition where that path
could sleep.  However, handling the possibility is an issue with the
existing code.  What this patchset does add is additional complexity
to the existing code paths.  It would be better to wait for modifications
that take into account put_page/free_huge_page can be called from any
context.

I am working on such changes and it is a priority.  However, this is
going to require quite a bit of code change.
-- 
Mike Kravetz
